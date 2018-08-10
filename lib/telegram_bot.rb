require 'excon'
require 'virtus'
require 'json'

require "telegram_bot/version"
require "telegram_bot/result"
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
require "telegram_bot/api_response"
require "telegram_bot/bot"
require "telegram_bot/client"
require "telegram_bot/location"


module TelegramBot
  def self.new(opts)
    # compatibility with just passing a token
    if opts.is_a?(String)
      opts = { token: opts }
    end

    opts[:logger] ||= NullLogger.new
    opts[:client] ||= Client.new(token: opts.fetch(:token), logger: opts[:logger], proxy: opts[:proxy])

    Bot.new(opts)
  end
end
