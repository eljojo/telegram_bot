require 'excon'
require 'virtus'
require 'json'

module TelegramBot
  {
    Version: "version",
    Result: "result",
    NullLogger: "null_logger",
    User: "user",
    Chat: "chat",
    MessageEntity: "message_entity",
    Message: "message",
    Keyboard: "keyboard",
    ReplyKeyboardHide: "reply_keyboard_hide",
    ReplyKeyboardMarkup: "reply_keyboard_markup",
    ForceReplay: "force_replay",
    Update: "update",
    ApiResponse: "api_response",
    Bot: "bot",
    Connection: "connection",
  }.each do |key, val|
    autoload(key, "telegram_bot/#{val}")
  end

  def self.new(opts)
    Bot.new(opts)
  end
end
