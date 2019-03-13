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
      entity = message.entities.first

      assert_equal "/start", message.text
      assert_equal "/start", message.get_bot_command
      assert_equal ["/start"], message.get_bot_commands
      assert_nil message.get_mention
      assert_equal true, message.chat.is_private?
      assert_equal false, message.chat.is_group?

      answer = message.reply do |reply|
        reply[:text] = "Hello, #{message.from.first_name}!"
        result = bot.send_message(**reply)

        assert_equal bot.get_me.id, result.from.id
        assert_equal result.text, reply[:text]
      end

      assert !message.from.is_bot?
      assert_includes ["enCA", nil], message.from.language_code
      assert_equal message.from.id, answer[:chat_id]
      assert_equal "Hello, José!", answer[:text]
      
      assert entity.is_bot_command?
    end
  end
end
