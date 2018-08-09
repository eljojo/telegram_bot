module TelegramBot
  class Client
    ENDPOINT = 'https://api.telegram.org/'

    def initialize(token:, logger:, proxy: nil)
      @token = token
      @logger = logger
      @proxy = proxy
      @connection = Excon.new(ENDPOINT, persistent: true, proxy: @proxy)
    end

    def request(action, query = {})
      path = "/bot#{@token}/#{action}"
      res = @connection.post(path: path, query: query.to_h)
      ApiResponse.from_excon(res)
    end

    private
    attr_reader :token
    attr_reader :logger
  end
end
