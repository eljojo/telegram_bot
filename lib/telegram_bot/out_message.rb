module TelegramBot
  class OutMessage
    include Virtus.model
    attribute :chat_id, Integer
    attribute :text, String

    def send_with(bot)
      bot.send_message(self)
    end
  end
end
