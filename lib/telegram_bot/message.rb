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

    def all_entities
      (entities || []) + (caption_entities || [])
    end

    MessageEntity::ENTITY_TYPES.each do |method_name|
      class_eval <<-DEF, __FILE__, __LINE__ + 1
        def get_#{method_name}s(return_entities=false)
          return [] unless all_entities.any?
          list_entities = all_entities.select(&:is_#{method_name}?)
          return list_entities if return_entities
          list_entities.map { |entity| entity.get_#{method_name}(self) }
        end
      DEF

      class_eval <<-DEF, __FILE__, __LINE__ + 1
        def get_#{method_name}(return_entity=false)
          return nil unless all_entities.any?
          entity = all_entities.find(&:is_#{method_name}?)
          return entity if return_entity
          entity.get_#{method_name}(self) if entity
        end
      DEF
    end
  end
end
