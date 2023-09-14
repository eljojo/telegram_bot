module TelegramBot
  class WebhookRequest
    include Virtus.model
    attribute :url, String
    attribute :allowed_updates, [String]
  end

  class UpdatesRequest
    include Virtus.model
    attribute :offset, Integer
    attribute :timeout, Integer

    def to_h
      result = super.select { |_, v| !!v }
      Hash[result]
    end
  end

  class Bot
    ENDPOINT = 'https://api.telegram.org/'
    attr_reader :connection

    def initialize(opts = {})
      # compatibility with just passing a token
      opts = {token: opts} if opts.is_a?(String)

      @token = opts.fetch(:token)
      @base_path = "/bot#{@token}"
      @offset = opts[:offset] || 0
      @logger = opts[:logger] || NullLogger.new
      @connection = Connection.new(ENDPOINT, persistent: true, proxy: opts[:proxy])
    end

    def get_me
      @me ||= @connection
        .get(path: "#{@base_path}/getMe")
        .and_then { |result| User.new(result) }
        .value!
    end
    alias_method :me, :get_me
    alias_method :identity, :me

    def get_updates(opts = {}, &block)
      return get_last_messages(opts) unless block_given?

      opts[:timeout] ||= 50
      logger.info "starting get_updates loop"
      loop do
        messages = get_last_messages(opts)
        opts[:offset] = @offset
        messages.compact.each do |message|
          next unless message
          logger.info "message from @#{message.chat.friendly_name}: #{message.text.inspect}"
          yield message
        end
      end
    end

    # send_message(chat_id:, text:, parse_mode: nil, disable_web_page_preview: nil, **kwargs)
    def send_message(*args, **kwargs)
      chat_id = kwargs.fetch(:chat_id) { args.fetch(0) }
      text = kwargs.fetch(:text) { args.fetch(1) }
      parse_mode = kwargs.fetch(:parse_mode) { args[2] }
      disable_web_page_preview = kwargs.fetch(:disable_web_page_preview) { args[3] }

      logger.info "sending message: #{text.inspect}"
      data = {text: text, chat_id: chat_id}
      data[:parse_mode] = parse_mode unless parse_mode.nil?
      data[:disable_web_page_preview] = disable_web_page_preview unless disable_web_page_preview.nil?

      args.shift(4)
      args.unshift("#{@base_path}/sendMessage", data)
      Message.new(post_message(*args, **kwargs))
    end

    def set_webhook(url, allowed_updates: %i(message))
      logger.info "setting webhook url to #{url}, allowed_updates: #{allowed_updates}"
      webhook_request = WebhookRequest.new(url: url, allowed_updates: allowed_updates)
      post_message(path: "#{@base_path}/setWebhook", data: webhook_request.to_h)
    end

    def remove_webhook
      set_webhook("")
    end

    private
      attr_reader :logger

      def get_last_updates(opts = {})
        opts[:offset] ||= @offset
        updates_request = UpdatesRequest.new(opts)
        path = "#{@base_path}/getUpdates"
        response = @connection.get(path: path, query: updates_request.to_h)
        if opts[:fail_silently] && !response.ok?
          logger.warn "error when getting updates. ignoring due to fail_silently."
          return []
        end
        updates = response.value!.compact.map { |raw_update| Update.new(raw_update) }
        @offset = updates.last.id + 1 if updates.any?
        updates
      end

      def get_last_messages(opts = {})
        get_last_updates(opts).map(&:get_message)
      end

      # post_message(path:, data: {}, disable_notification: nil, reply_to_message_id: nil, content_type: nil)
      def post_message(*args, **kwargs)
        path = kwargs.fetch(:path) { args.fetch(0) }
        data = kwargs.fetch(:data) { args.fetch(1, {}) }
        disable_notification = kwargs.fetch(:disable_notification) { args[2] }
        reply_to_message_id = kwargs.fetch(:reply_to_message_id) { args[3] }
        content_type = kwargs.fetch(:content_type) { args[4] }

        data[:disable_notification] = disable_notification unless disable_notification.nil?
        data[:reply_to_message_id] = reply_to_message_id unless reply_to_message_id.nil?

        if content_type.nil?
          content_type = "application/x-www-form-urlencoded"
          data = URI.encode_www_form(data)
        else
          content_type = content_type.downcase
        end

        if content_type == "application/json"
          data = JSON.dump(data)
        end

        @connection.post(path: path, body: data, headers: {"Content-Type" => content_type}).value!
      end
  end
end
