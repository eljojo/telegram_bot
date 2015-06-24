module TelegramBot
  class User
    include Virtus.model
    attribute :id, Integer
    alias_method :to_i, :id
    attribute :first_name, String
    attribute :last_name, String
    attribute :username, String
  end
end
