require 'telegram_bot'
require 'minitest/autorun'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :excon
  config.filter_sensitive_data('TEST_BOT_API_TOKEN') { ENV['TEST_TOKEN'] }
  config.filter_sensitive_data('1234') { ENV['TEST_BOT_ID'] }
  config.filter_sensitive_data('5678') { ENV['TEST_RECEIVER_ID'] }
  config.filter_sensitive_data('bob_bobsen') { ENV['TEST_RECEIVER_HANDLE'] }
end

module TestHelper
  def new_test_bot
    TelegramBot.new(token: ENV['TEST_TOKEN'])
  end

  def fixture_bot_user
    TelegramBot::User.new(
      id: ENV['TEST_BOT_ID'],
      first_name: "telegram-bot-gem-test",
      username: "gem_test_bot"
    )
  end
end
