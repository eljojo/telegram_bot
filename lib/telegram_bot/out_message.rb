module TelegramBot
  class OutMessage
    include Virtus.model
    attribute :chat, Channel
    attribute :text, String
    attribute :reply_to, Message
    attribute :parse_mode, String
    attribute :disable_web_page_preview, Boolean

    def send_with(bot)
      bot.send_message(self)
    end

    def chat_friendly_name
      chat.friendly_name
    end

    def to_h
      message = {
          text: text,
          chat_id: chat.id
      }

      message[:reply_to_message_id] = reply_to.id unless reply_to.nil?
      message[:parse_mode] = parse_mode unless parse_mode.nil?
      message[:disable_web_page_preview] = disable_web_page_preview unless disable_web_page_preview.nil?

      message
    end
  end
end
