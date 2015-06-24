# TelegramBot

A charismatic client for [Telegram's Bot API](https://core.telegram.org/bots).

Write your own Telegram Bot!

Currently under heavy development.
Contributions are always welcome.

## Installation

Add this line to your application's Gemfile (currently under development):

```ruby
gem 'telegram_bot', github: 'eljojo/telegram_bot'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install telegram_bot

## Usage

Here's an example:

```ruby
require 'telegram_bot'
require 'pp'

bot = TelegramBot.new('[YOUR TELEGRAM BOT TOKEN GOES HERE]')
bot.get_updates do |message|
  pp(message)
  command = message.get_command_for(bot)

  message.reply do |reply|
    reply.text = "i think that #{command.inspect} is false"
    pp(reply)
    reply.send_with(bot)
  end
end
```

## How do I get a Bot Token

Talk to the [@BotFather](https://telegram.me/botfather).
You can find more info [here](https://core.telegram.org/bots).

## Contributing

1. Fork it ( https://github.com/eljojo/telegram_bot/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
