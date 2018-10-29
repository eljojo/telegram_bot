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
    attribute :entities, Array[MessageEntity]

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
