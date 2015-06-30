module TelegramBot
  class Channel
    include Virtus.model
    attribute :id, Integer
    attribute :username, String
    attribute :title, String

    def friendly_name
      username ? "@#{username}" : "channel #{title.inspect}"
    end
  end
end
