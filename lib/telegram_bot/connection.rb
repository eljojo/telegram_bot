module TelegramBot
  class Connection
    attr_reader :connection

    def initialize(url, params = {})
      @connection = Excon.new(url, params)
    end

    def request(params = {}, &block)
      response = @connection.request(params, &block)
      ApiResponse.from_excon(response)
    end

    Excon::HTTP_VERBS.each do |method|
      define_method(method) do |params = {}, &block|
        request(params.merge(method: method), &block)
      end
    end
  end
end
