defmodule LlmizerWeb.ChatsShowLiveTest do
  use LlmizerWeb.ConnCase
  alias Llmizer.Chats

  describe "GET /chats/:id" do
    test "renders one chat", %{conn: conn} do
      {:ok, chat} = Chats.create_chat(%{name: "Test Chat"})

      conn = get(conn, ~p"/chats/#{chat.id}")
      assert html_response(conn, 200) =~ "Test Chat"
    end

    test "renders one chat messages", %{conn: conn} do
      {:ok, chat} = Chats.create_chat(%{name: "Test Chat"})

      {:ok, %{content: message_content}} =
        Chats.create_chat_message(%{chat_id: chat.id, content: "Hello, world!", role: "user"})

      conn = get(conn, ~p"/chats/#{chat.id}")

      assert html_response(conn, 200) =~ "Test Chat"
      assert html_response(conn, 200) =~ message_content
    end
  end
end
