module TelegramBot
  class ApiResponseError < StandardError
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
end