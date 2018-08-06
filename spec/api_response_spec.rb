# frozen_string_literal: true
require 'minitest_helper'

describe TelegramBot::ApiResponse do
  ApiResponse = TelegramBot::ApiResponse
  ExampleResponse = Struct.new(:body, :status)

  def test_error_handling
    body = { "result" => "oops" }
    example_response = ExampleResponse.new(JSON.dump(body), 404)
    response = ApiResponse.new(example_response)

    refute response.ok?
    assert_kind_of ApiResponse::ResponseError, response.error
    assert_raises(ApiResponse::ResponseError) do
      response.value!
    end
    assert_equal body, response.error.data
  end

  def test_success_case
    body = { "result" => "hello" }
    example_response = ExampleResponse.new(JSON.dump(body), 200)
    response = ApiResponse.new(example_response)

    assert response.ok?
    assert_nil response.error
    assert_equal "hello", response.value!
  end
end
