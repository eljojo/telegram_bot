module TelegramBot
  class User
    include Virtus.model
    attribute :id, Integer
    alias_method :to_i, :id
    attribute :first_name, String
    attribute :last_name, String
    attribute :username, String
    attribute :is_bot, Boolean, default_value: false
    attribute :language_code, String

    def ==(other)
      other.is_a?(self.class) && other.hash == hash
    end

    def hash
      to_h.hash
    end
  end
end
