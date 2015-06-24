module TelegramBot
  class GroupChat
    include Virtus.model
    attribute :id, Integer
    alias_method :to_i, :id
    attribute :title, String
  end
end
