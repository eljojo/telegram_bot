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

    def send_message(out_message)
      logger.info "sending message: #{out_message.text.inspect} to #{out_message.chat_friendly_name}"
      path = "#{@base_path}/sendMessage"
      @connection
        .post(path: path, query: out_message.to_h)
        .and_then { |result| Message.new(result) }
        .value!
    end

    def set_webhook(url, allowed_updates: %i(message))
      logger.info "setting webhook url to #{url}, allowed_updates: #{allowed_updates}"
      webhook_request = WebhookRequest.new(url: url, allowed_updates: allowed_updates)
      path = "#{@base_path}/setWebhook"
      @connection.post(path: path, query: webhook_request.to_h)
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
  end
end
