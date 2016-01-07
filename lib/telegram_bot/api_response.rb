module TelegramBot
  class ApiResponse
    attr_reader :body, :ok, :result, :description, :error_code

    def initialize(res)
      @body = res.body
      if res.status == 200
        data = JSON.parse(body)
        @ok = data["ok"]
        @result = data["result"]
      else
        data = JSON.parse(body)
        @ok = false
        @description = data["description"]
        @error_code = data["error_code"]
      end
    end

    alias_method :ok?, :ok
  end
end
