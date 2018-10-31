module TelegramBot
  class Update
    include Virtus.model
    attribute :update_id, Integer
    alias_method :id, :update_id
    alias_method :to_i, :id
    attribute :message, Message
    attribute :edited_message, Message
    attribute :channel_post, Message
    attribute :edited_channel_post, Message

    def get_message
      message || edited_message || channel_post || edited_channel_post
    end
  end
end
