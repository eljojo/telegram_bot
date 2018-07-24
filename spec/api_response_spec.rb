require 'minitest_helper'

describe TelegramBot::ApiResponse do
  it 'does not raise uninitialized constant TelegramBot::ApiResponse::ResponseError' do
    expect { described_class.new(double(body: "{\"error\":\"test\"}", status: 500)) }.not_to raise_error(NameError)
  end
end
