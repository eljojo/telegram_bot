module TelegramBot
  class ForceReply < Keyboard

    #	Shows reply interface to the user, as if they manually selected the bot‘s message and tapped ’Reply'
    # Always true
    # attribute :force_reply, Boolean

    # Optional. Use this parameter if you want to force reply from specific users only.
    # Targets:
    # 1) users that are @mentioned in the text of the Message object;
    # 2) if the bot's message is a reply (has reply_to_message_id), sender of the original message.
    attribute :selective, Boolean, :default => false

  end


  def to_h
    h = {force_reply: true}
    h[:selective] = selective unless selective.nil?
    h
  end
end