require 'telegram_bot'
require 'pp'
require 'logger'

logger = Logger.new(STDOUT, Logger::DEBUG)

bot = TelegramBot.new(token: 'YOUR KEY GOES HERE', logger: logger)
logger.debug "starting telegram bot"

bot.get_updates(fail_silently: true) do |message|
  msg_text = message.text
  logger.info "@#{message.from.username}: #{msg_text}"

  message.reply do |reply|
    case msg_text
    when /greet/i
      reply.text = "Hello, #{message.from.first_name}!"
    else
      reply.text = "#{message.from.first_name}, have no idea what #{msg_text.inspect} means."
    end
    logger.info "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
