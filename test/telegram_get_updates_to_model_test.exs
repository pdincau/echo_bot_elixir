defmodule TelegramGetUpdatesToModelTest do
  use ExUnit.Case

  test "returns nil if cannot convert GetUpdatesResponse" do
    getUpdatesResponse = %GetUpdatesResponse{}

    result = TelegramMessageUpdatesMapper.buildWith getUpdatesResponse

    assert result == nil
  end

  test "returns GetUpdatesResponse with empty messages if can convert GetUpdatesResponse" do
    getUpdatesResponse = %GetUpdatesResponse{ok: true, result: []}

    result = TelegramMessageUpdatesMapper.buildWith getUpdatesResponse
    expected = %TelegramMessageUpdates{latest_update_id: nil, messages: []}

    assert result != nil
    assert result == expected
  end

  test "returns GetUpdatesResponse with messages if can convert GetUpdatesResponse" do
    getUpdatesResponse = %GetUpdatesResponse{ok: true, result: [%{"message" => %{"chat" => %{"first_name" => "cf","id" => 27922851,"username" => "cfcfcfcf"},"date" => 1438213716,"from" => %{"first_name" => "cf","id" => 27922851,"username" => "cfcfcfcf"},"message_id" => 35,"text" => "/echo test"},"update_id" => 968217487}]}

    result = TelegramMessageUpdatesMapper.buildWith getUpdatesResponse
    expected = %TelegramMessageUpdates{latest_update_id: 968217487, messages: [%{
      "text" => "/echo test",
      "chat_id" => 27922851,
      "update_id" => 968217487
    }]}

    assert result != nil
    assert result == expected
  end
end