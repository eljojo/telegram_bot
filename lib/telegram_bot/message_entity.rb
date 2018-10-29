module TelegramBot
  class MessageEntity
    include Virtus.model

    MENTION = "mention"
    HASHTAG = "hashtag"
    CASHTAG = "cashtag"
    BOT_COMMAND = "bot_command"
    URL = "url"
    EMAIL = "email"
    PHONE_NUMBER = "phone_number"
    BOLD = "bold"
    ITALIC = "italic"
    CODE = "code"
    PRE = "pre"
    TEXT_LINK = "text_link"
    TEXT_MENTION = "text_mention"
    TYPES_ENTITY = [
      MENTION, HASHTAG, CASHTAG, BOT_COMMAND, URL, EMAIL,
      PHONE_NUMBER, BOLD, ITALIC, CODE, PRE, TEXT_LINK, TEXT_MENTION
    ]

    attribute :type, String
    attribute :offset, Integer
    attribute :length, Integer
    attribute :url, String
    attribute :user, User

    def is_type?(type_entity)
      type == type_entity
    end

    TYPES_ENTITY.each do |method_name|
      define_method("is_#{method_name}?") do
        is_type?(method_name)
      end
    end
  end
end