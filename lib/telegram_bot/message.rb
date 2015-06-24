module TelegramBot
  class Message
    include Virtus.model
    attribute :message_id, Integer
    alias_method :id, :message_id
    alias_method :to_i, :id
    attribute :from, User
    alias_method :user, :from
    attribute :text, String
    attribute :date, DateTime
    attribute :chat, Channel
    attribute :reply_to_message, Message

    def reply(&block)
      reply = OutMessage.new(chat_id: chat.id)
      yield reply if block_given?
      reply
    end

    def get_command_for(bot)
      text && text.sub(Regexp.new("@#{bot.identity.username}($|\s|\.|,)", Regexp::IGNORECASE), '').strip
    end
  end
end
