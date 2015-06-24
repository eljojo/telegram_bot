module TelegramBot
  class Update
    include Virtus.model
    attribute :update_id, Integer
    alias_method :id, :update_id
    alias_method :to_i, :id
    attribute :message, Message
  end
end
