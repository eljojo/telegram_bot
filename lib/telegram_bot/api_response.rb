module TelegramBot
  class ApiResponse
    attr_reader :body, :ok, :result

    def initialize(res)
      @body = res.body
      if res.status == 200
        data = JSON.parse(body)
        @ok = data["ok"]
        @result = data["result"]
      else
        @ok = false
      end
    end

    alias_method :ok?, :ok
  end
end
