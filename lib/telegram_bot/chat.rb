module TelegramBot
  class Chat
    include Virtus.model
    attribute :id, Integer
    attribute :type, String
    attribute :title, String
    attribute :username, String
    attribute :first_name, String
    attribute :last_name, String
    attribute :all_members_are_administrators, Boolean
    attribute :description, String
    attribute :invite_link, String
    attribute :pinned_message, Message
    attribute :sticker_set_name, String
    attribute :can_set_sticker_set, Boolean

    def friendly_name
      username ? "@#{username}" : "chat #{title.inspect}"
    end
  end
end
