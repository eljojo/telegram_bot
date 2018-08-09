module TelegramBot
  class Result
    attr_reader :error

    def self.rescue
      begin
        value = yield
        return value if value.is_a?(self)
        new(value, nil)
      rescue => e
        new(nil, e)
      end
    end

    def initialize(value, error = nil)
      @value, @error = value, error
      @ok = error.nil?
    end

    def ok?
      @ok
    end

    def value!
      raise error unless ok?
      @value
    end

    def and_then
      ok? ? self.class.rescue { yield(value!) } : self
    end

    def on_error
      ok? ? self : self.class.rescue { yield(error) }
    end
  end
end
