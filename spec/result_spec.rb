# frozen_string_literal: true
require 'minitest_helper'

describe TelegramBot::Result do
  Result = TelegramBot::Result
  ExampleError = Class.new(StandardError)

  def test_error_handling
    result = Result.rescue do
      raise ExampleError
    end

    refute result.ok?
    assert_kind_of ExampleError, result.error
    assert_raises(ExampleError) do
      result.value!
    end

    and_then_result = result.and_then do |value|
      fail "this shouldn't be triggered"
    end
    assert_equal result, and_then_result

    on_error_result = result.on_error do |original_error|
      assert_kind_of ExampleError, original_error
      "some other value"
    end
    assert_equal "some other value", on_error_result.value!
  end

  def test_success_case
    result = Result.rescue do
      "some value"
    end

    assert result.ok?
    assert_nil result.error
    assert_equal "some value", result.value!

    and_then_result = result.and_then do |value|
      assert_equal "some value", value
      "some other value"
    end
    assert_equal "some other value", and_then_result.value!

    on_error_result = result.on_error do |value|
      fail "this shouldn't be triggered"
    end
    assert_equal result, on_error_result
  end
end
