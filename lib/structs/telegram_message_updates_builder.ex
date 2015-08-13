defmodule TelegramMessageUpdatesMapper do
  def buildWith getUpdatesResponse do
    case getUpdatesResponse do
      %{"ok" => false, "result" => []} ->
        nil;
      %{"ok" => true, "result" => result} ->
        latest_update_id = get_latest_update_id result
        messages = mapToMessages result
        %TelegramMessageUpdates{latest_update_id: latest_update_id, messages: messages}
    end
  end


  defp mapToMessages [] do
    []
  end

  defp mapToMessages [head | tail] do
    mappedMessage = %{
      "text" => head["message"]["text"],
      "chat_id" => head["message"]["chat"]["id"],
      "update_id" => head["update_id"]
    }
    [mappedMessage | mapToMessages tail]
  end


  defp get_latest_update_id([]), do: nil

  defp get_latest_update_id(results) do
    [h|_] = Enum.reverse results
    h["update_id"]
  end

end
