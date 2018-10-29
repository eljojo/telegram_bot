module TelegramBot
  class Message
    include Virtus.model
    attribute :message_id, Integer
    alias_method :id, :message_id
    alias_method :to_i, :id
    attribute :from, User
    alias_method :user, :from
    attribute :date, DateTime
    attribute :chat, Channel
    attribute :forward_from, User
    attribute :forward_from_chat, Channel
    attribute :forward_from_message_id, Integer
    attribute :forward_signature, String
    attribute :forward_date, DateTime
    attribute :reply_to_message, Message
    attribute :edit_date, DateTime
    attribute :media_group_id, String
    attribute :author_signature, String
    attribute :text, String
    attribute :entities, Array[MessageEntity]
    attribute :caption_entities, Array[MessageEntity]
    attribute :caption, String
    attribute :new_chat_members, Array[User]
    attribute :left_chat_member, User
    attribute :new_chat_title, String
    attribute :delete_chat_photo, Boolean, default: false
    attribute :group_chat_created, Boolean, default: false
    attribute :supergroup_chat_created, Boolean, default: false
    attribute :channel_chat_created, Boolean, default: false
    attribute :migrate_to_chat_id, Integer
    attribute :migrate_from_chat_id, Integer
    attribute :pinned_message, Message
    attribute :connected_website, String

    def reply(&block)
      reply = OutMessage.new(chat: chat)
      yield reply if block_given?
      reply
    end

    MessageEntity::TYPES_ENTITY.each do |method_name|
      singular_name_of_method = "get_#{method_name}"
      is_type_method = "is_#{method_name}?".to_sym

      define_method("#{singular_name_of_method}s") do
        return [] if entities.nil?
        entities.select(&is_type_method).map { |entity| text[entity.offset..-1] }
      end

      define_method(singular_name_of_method) do
        return nil if entities.nil?
        entity = entities.find(&is_type_method)
        text[entity.offset..-1] unless entity.nil?
      end
    end
  end
end
