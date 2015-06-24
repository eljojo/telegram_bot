module TelegramBot
  class Bot
    ENDPOINT = 'https://api.telegram.org/'

    attr_reader :me
    alias_method :identity, :me

    def initialize(token)
      @token = token
      @timeout = 50
      @offset = 0
      @connection = Excon.new(ENDPOINT, persistent: true)
      @me = get_me
    end

    def get_me
      response = request(:getMe)
      User.new(response.result)
    end

    def get_updates(&block)
      loop do
        response = request(:getUpdates, offset: @offset, timeout: @timeout)
        response.result.each do |raw_update|
          update = Update.new(raw_update)
          @offset = update.id + 1
          yield update.message
        end
      end
    end

    def send_message(out_message)
      response = request(:sendMessage, out_message.to_h)
      Message.new(response.result)
    end


    private
    attr_reader :token
    def request(action, query = {})
      path = "/bot#{@token}/#{action}"
      res = @connection.post(path: path, query: query)
      ApiResponse.new(res)
    end
  end
end
