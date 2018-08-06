module TelegramBot
  class ApiResponse < Result
    class ResponseError < StandardError
      attr_reader :response

      def initialize(res)
        @response = res
      end

      def data
        @data ||= begin
                    JSON.parse(response.body)
                  rescue JSON::ParserError
                    { error_code: response.status, error_message: response.reason_phrase }
                  end
      end
    end

    def self.from_excon(res)
      body = res.body
      if res.status == 200
        data = JSON.parse(body)
        new(data["result"], nil)
      else
        error = ResponseError.new(res)
        new(nil, error)
      end
    end
  end
end
