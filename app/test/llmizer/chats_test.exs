defmodule Llmizer.ChatsTest do
  use Llmizer.DataCase, async: true

  alias Llmizer.Chats

  describe "create_chat/1" do
    test "returns the chat" do
      {:ok, chat} = Chats.create_chat(%{name: "Test Chat"})

      assert chat.name == "Test Chat"
      assert chat.id
    end
  end

  describe "list_chats/0" do
    test "returns all chats" do
      {:ok, _} = Chats.create_chat(%{name: "Test Chat 1"})
      {:ok, _} = Chats.create_chat(%{name: "Test Chat 2"})

      chats = Chats.list_chats()
      assert length(chats) == 2
    end
  end

  describe "create_new_chat/1" do
    test "creates a new chat with a response from the model" do
      attrs = %{question: "What is Elixir?"}
      {:ok, chat} = Chats.create_new_chat(attrs)

      assert chat.name == "Simple chat"
      assert length(chat.chat_messages) == 2

      assert Enum.any?(chat.chat_messages, fn msg ->
               msg.role == "user" && msg.content == attrs.question
             end)
    end
  end

  describe "get_chat!/1" do
    test "returns the chat with preloaded messages" do
      {:ok, chat} = Chats.create_chat(%{name: "Test Chat"})

      fetched_chat = Chats.get_chat!(chat.id)
      assert fetched_chat.name == "Test Chat"
    end
  end

  describe "create_chat_message/1" do
    test "creates a chat message" do
      {:ok, chat} = Chats.create_chat(%{name: "Test Chat"})
      attrs = %{content: "Hello, world!", role: "user", chat_id: chat.id}

      {:ok, chat_message} = Chats.create_chat_message(attrs)

      assert chat_message.content == "Hello, world!"
      assert chat_message.role == "user"
      assert chat_message.chat_id == chat.id
    end
  end

  describe "add_message_to_chat/2" do
    test "attaches a message to the chat" do
      attrs = %{question: "What is Elixir?"}
      {:ok, chat} = Chats.create_new_chat(attrs)

      {:ok, chat} = Chats.add_message_to_chat(chat.id, %{question: "What is Phoenix?"})
      assert length(chat.chat_messages) == 4
    end
  end
end
