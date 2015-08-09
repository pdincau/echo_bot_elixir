defmodule TelegramApi do

  @token Application.get_env(:echo_bot_elixir, :telegram_api_token)

  def get_updates offset do
    url = "https://api.telegram.org/bot#{@token}/getUpdates?offset=#{offset}"
    |> do_request(:get)
    |> handle_result
  end

  def send_message chat_id, text do
    call_params_from(chat_id, text)
    |> do_request(:post)
    |> handle_result
  end

  defp call_params_from chat_id, text do
    url = "https://api.telegram.org/bot#{@token}/sendMessage"
    headers = %{"Content-type": "application/x-www-form-urlencoded"}
    body = {:form, [chat_id: chat_id, text: text]}
    {url, headers, body}
  end

  defp do_request(url, :get), do: HTTPoison.get(url)

  defp do_request({url, headers, body}, :post), do: HTTPoison.post(url, body, headers)

  defp handle_result result do
    case result do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

end
