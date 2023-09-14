module TelegramBot
  class User
    include Virtus.model
    attribute :id, Integer
    alias_method :to_i, :id
    attribute :first_name, String
    attribute :last_name, String
    attribute :username, String
    attribute :is_bot, Boolean
    attribute :language_code, String

    def ==(other)
      other.is_a?(self.class) && other.hash == hash
    end

    def full_name
      @last_name ? "#{@first_name} #{@last_name}" : @first_name
    end

    def hash
      to_h.hash
    end
  end
end
