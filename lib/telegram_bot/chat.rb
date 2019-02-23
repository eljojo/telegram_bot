module TelegramBot
  class Chat
    include Virtus.model
    attribute :id, Integer
    attribute :username, String
    attribute :title, String

    def friendly_name
      username ? "@#{username}" : "chat #{title.inspect}"
    end
  end
end
