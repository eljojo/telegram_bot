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
    ENTITY_TYPES = [
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

    ENTITY_TYPES.each do |method_name|
      class_eval <<-DEF, __FILE__, __LINE__ + 1
        def is_#{method_name}?
          is_type?("#{method_name}")
        end
      DEF

      class_eval <<-DEF, __FILE__, __LINE__ + 1
        def get_#{method_name}(message, only_#{method_name}: false)
          limit = -1
          limit += offset + length if only_#{method_name}
          message.text[offset..limit] if is_#{method_name}?
        end
      DEF
    end
  end
end