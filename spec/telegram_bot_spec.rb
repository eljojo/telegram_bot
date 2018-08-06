require 'minitest_helper'

describe TelegramBot do
  include TestHelper

  def test_initialization
    bot = new_test_bot
    assert_kind_of TelegramBot::Bot, bot
  end

  def test_get_me
    bot = new_test_bot
    VCR.use_cassette("get_me") do
      assert_equal fixture_bot_user, bot.get_me
    end
  end

  def test_integration
    VCR.use_cassette("integration_test") do
      bot = new_test_bot
      messages = bot.get_updates
      message = messages.first

      assert_equal "/start", message.text

      answer = message.reply do |reply|
        reply.text = "Hello, #{message.from.first_name}!"
        result = reply.send_with(bot)

        assert_equal bot.get_me.id, result.from.id
        assert_equal result.text, reply.text
      end

      assert_equal message.from.id, answer.chat.id
      assert_equal "Hello, José!", answer.text
    end
  end
end
