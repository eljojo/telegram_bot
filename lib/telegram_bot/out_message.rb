module TelegramBot
  class OutMessage
    include Virtus.model
    attribute :chat, Channel
    attribute :text, String
    attribute :reply_to, Message
    attribute :parse_mode, String

    def send_with(bot)
      bot.send_message(self)
    end

    def chat_friendly_name
      chat.friendly_name
    end

    def to_h
      if reply_to.nil? then
        {
          text: text,
          chat_id: chat.id,
          parse_mode: parse_mode
        }
      else
        {
          text: text,
          chat_id: chat.id,
          reply_to_message_id: reply_to.id,
          parse_mode: parse_mode
        }
      end
    end
  end
end
