defmodule Llmizer.Chats do
  alias Llmizer.Repo

  @docker_client Application.compile_env(:llmizer, :docker_client)

  def get_chat!(id) do
    Repo.get!(Llmizer.Chats.Chat, id) |> Repo.preload(:chat_messages)
  end

  def create_chat_message(attrs \\ %{}) do
    %Llmizer.Chats.ChatMessage{}
    |> Llmizer.Chats.ChatMessage.changeset(attrs)
    |> Llmizer.Repo.insert()
  end

  def create_new_chat(attrs \\ %{}) do
    messages = [
      %{role: "system", content: "You are a helpful assistant."},
      %{role: "user", content: attrs[:question]}
    ]

    case @docker_client.get_chat_completions(messages) do
      {:ok, body} ->
        response = body[:choices] |> List.first() |> Map.get(:message) |> Map.get(:content)

        {:ok, chat} = create_chat(%{name: attrs[:name]})

        chat
        |> Repo.preload(:chat_messages)
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:chat_messages, [
          %Llmizer.Chats.ChatMessage{content: attrs[:question], role: "user"},
          %Llmizer.Chats.ChatMessage{content: response, role: "assistant"}
        ])
        |> Repo.update()
    end
  end

  def add_message_to_chat(chat_id, attrs \\ %{}) do
    chat = get_chat!(chat_id)

    messages =
      Enum.map(chat.chat_messages, fn msg ->
        %{role: msg.role, content: msg.content}
      end)
      |> Enum.concat([
        %{role: "user", content: attrs[:question]}
      ])

    case @docker_client.get_chat_completions(messages) do
      {:ok, body} ->
        response = body[:choices] |> List.first() |> Map.get(:message) |> Map.get(:content)

        chat
        |> Ecto.Changeset.change()
        |> Ecto.Changeset.put_assoc(:chat_messages, [
          %Llmizer.Chats.ChatMessage{content: attrs[:question], role: "user"},
          %Llmizer.Chats.ChatMessage{content: response, role: "assistant"}
          | chat.chat_messages
        ])
        |> Repo.update()
    end
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
