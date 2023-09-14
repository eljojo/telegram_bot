module TelegramBot
  class Chat
    include Virtus.model

    PRIVATE = "private"
    GROUP = "group"
    SUPERGROUP = "supergroup"
    CHANNEL = "channel"
    CHAT_TYPES = [PRIVATE, GROUP, SUPERGROUP, CHANNEL]

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

    def is_type?(chat_type)
      type == chat_type
    end

    CHAT_TYPES.each do |chat_type|
      class_eval <<-DEF, __FILE__, __LINE__ + 1
        def is_#{chat_type}?
          is_type?("#{chat_type}")
        end
      DEF
    end

    # send_message(bot:, text:, parse_mode: nil, disable_web_page_preview: nil, **kwargs)
    def send_message(*args, **kwargs)
      bot = kwargs.fetch(:bot) { args.fetch(0) }
      args[0] = id
      kwargs[:chat_id] = id
      bot.send_message(*args, **kwargs)
    end
  end
end
