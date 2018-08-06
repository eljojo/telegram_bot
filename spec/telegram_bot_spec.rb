require 'minitest_helper'

describe TelegramBot do
  def test_initialization
    bot = TelegramBot.new(token: 'test')
    assert_kind_of TelegramBot::Bot, bot
  end
end
