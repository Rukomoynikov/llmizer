defmodule Llmizer.DockerModelClient do
  @moduledoc """
  A client for interacting with a Docker-based LLM model.
  """

  def get_chat_completions(messages), do: send_request(:chat_completions, messages)

  defp send_request(:chat_completions, messages) do
    url = System.get_env("AI_RUNNER_URL") <> "chat/completions"

    params = %{
      model: System.get_env("AI_RUNNER_MODEL"),
      messages: messages
    }

    send_request(url, params)
  end

  defp send_request(url, params) do
    case Req.post(url, json: params, decode_json: [keys: :atoms]) do
      {:ok, %Req.Response{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %Req.Response{status: 404}} ->
        {:error, :not_found}

      {:ok, %Req.Response{status: 500, body: %{error: %{message: message}}}} ->
        {:error, message}
    end
  end
end
