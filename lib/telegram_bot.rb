require 'excon'
require 'virtus'
require 'json'

require "telegram_bot/version"
require "telegram_bot/null_logger"
require "telegram_bot/user"
require "telegram_bot/group_chat"
require "telegram_bot/channel"
require "telegram_bot/message"
require "telegram_bot/keyboard"
require "telegram_bot/reply_keyboard_hide"
require "telegram_bot/reply_keyboard_markup"
require "telegram_bot/force_replay"
require "telegram_bot/out_message"
require "telegram_bot/update"
require "telegram_bot/api_response_error"
require "telegram_bot/api_response"
require "telegram_bot/bot"


module TelegramBot
  def self.new(*args)
    Bot.new(*args)
  end
end
