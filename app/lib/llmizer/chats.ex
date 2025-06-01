defmodule Llmizer.Chats do
  alias Llmizer.Repo

  def get_chat!(id) do
    Repo.get!(Llmizer.Chats.Chat, id) |> Repo.preload(:chat_messages)
  end

  def create_chat_message(attrs \\ %{}) do
    %Llmizer.Chats.ChatMessage{}
    |> Llmizer.Chats.ChatMessage.changeset(attrs)
    |> Llmizer.Repo.insert()
  end

  def create_chat(attrs \\ %{}) do
    %Llmizer.Chats.Chat{}
    |> Llmizer.Chats.Chat.changeset(attrs)
    |> Repo.insert()
  end

  def list_chats do
    Repo.all(Llmizer.Chats.Chat)
  end
end
