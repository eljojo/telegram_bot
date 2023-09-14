# This gem has been archived

Hi everyone, I haven't touched this code in a long time and I decided it may be best to archive the repo and put it to rest.  
I hope this project helped many people get started in bot development, I had fun working on it.

I would recommend using https://github.com/atipugin/telegram-bot-ruby.

# TelegramBot

A charismatic ruby client for [Telegram's Bot API](https://core.telegram.org/bots).

Write your own Telegram Bot using Ruby! Yay!

Currently under heavy development.
Please [collaborate](https://github.com/eljojo/telegram_bot/issues/new) with your questions, ideas or problems!

## Installation

Add this line to your application's Gemfile (currently under development):

```ruby
gem 'telegram_bot'
```

And then execute:

    $ bundle

## Usage

Here's an example:

```ruby
require 'telegram_bot'

bot = TelegramBot.new(token: '[YOUR TELEGRAM BOT TOKEN GOES HERE]')
bot.get_updates(fail_silently: true) do |message|
  puts "@#{message.from.username}: #{message.text}"
  command = message.get_command_for(bot)

  message.reply do |reply|
    case command
    when /greet/i
      reply.text = "Hello, #{message.from.first_name}!"
    else
      reply.text = "#{message.from.first_name}, have no idea what #{command.inspect} means."
    end
    puts "sending #{reply.text.inspect} to @#{message.from.username}"
    reply.send_with(bot)
  end
end
```

Here's a sample output:

```
$ bundle exec ruby bot.rb
@eljojo: greet
sending "Hello, José!" to @eljojo
@eljojo: heeeeeeeeya!
sending "José, have no idea what \"heeeeeeeeya!\" means." to @eljojo
```

![Example](http://i.imgur.com/VF8X4CQ.png)

## How do I get a Bot Token

Talk to the [@BotFather](https://telegram.me/botfather).
You can find more info [here](https://core.telegram.org/bots).

![How to get Token](http://i.imgur.com/90ya4Oe.png)

## What else can it do?

you can pass options to the bot initializer:
```ruby
bot = TelegramBot.new(token: 'abc', logger: Logger.new(STDOUT), offset: 123, timeout: 20)
```

if you don't want to start the loop, don't pass a block to ``#get_updates`` and you'll get an array with the latest messages:
```ruby
messages = bot.get_updates(timeout: 30, offset: 123)
```

Because things can go wrong sometimes with the API, there's a ``fail_silently`` option that you can pass to ``#get_updates`` like this:
```ruby
bot.get_updates(fail_silently: true) do |message|
  puts message.text
end
```

A message has several attributes:
```ruby
message = bot.get_updates.last

# message data
message.text # "hello moto"
message.date # Wed, 01 Jul 2015 09:52:54 +0200 (DateTime)

# reading user
message.from # TelegramBot::User
message.from.first_name # "Homer"
message.from.last_name  # "Simpson"
message.from.username   # "mr_x"

# channel
message.channel.id # 123123123 (telegram's id)

# reply
message.reply do |reply|
  reply.text = "homer please clean the garage"
  reply.send_with(bot)
end
# or
reply = message.reply
reply.text = "i'll do it after going to moe's"
bot.send_message(reply)
```

To send message to specific channel you could do following:

```ruby
bot = TelegramBot.new(token: '[YOUR TELEGRAM BOT TOKEN GOES HERE]')
channel = TelegramBot::Channel.new(id: channel_id)
message = TelegramBot::OutMessage.new
message.chat = channel
message.text = 'Some message'

message.send_with(bot)

```

Also you may pass additional options described in [API Docs](https://core.telegram.org/bots/api#sendmessage)

```ruby
message.parse_mode = 'Markdown'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/eljojo/telegram_bot. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](https://www.contributor-covenant.org/) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
