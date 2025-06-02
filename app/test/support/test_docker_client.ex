defmodule Llmizer.TestDockerModelClient do
  @moduledoc """
  A test implementation of the Docker model client.
  This client is used in tests to mock the behavior of the Docker model client.
  """

  def get_chat_completions(_messages) do
    {:ok, %{choices: [%{message: %{content: "This is a mock response from the test client."}}]}}
  end
end
