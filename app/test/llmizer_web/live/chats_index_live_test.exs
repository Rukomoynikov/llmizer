defmodule LlmizerWeb.ChatsIndexLiveTest do
  import Phoenix.LiveViewTest

  use LlmizerWeb.ConnCase
  alias Llmizer.Chats

  describe "GET /index" do
    test "renders list of chats", %{conn: conn} do
      Chats.create_chat(%{name: "Test Chat"})

      conn = get(conn, ~p"/")
      assert html_response(conn, 200) =~ "Your chats"
      assert html_response(conn, 200) =~ "Test Chat"
    end
  end

  describe "fill new chat form" do
    test "if form is filled correctly", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/")

      view
      |> form("#new-chat-form", chat_message: %{content: "hello"})
      |> render_submit()

      assert_redirect(view, ~p"/chats/1")
    end
  end

  #  describe "POST /chats" do
  #    test "creates one chat", %{conn: conn} do
  #      conn = post(conn, ~p"/chats", chat_message: %{content: "New Chat"})
  #      assert redirected_to(conn) == ~p"/chats/1"
  #
  #      assert Chats.get_chat!(1).name == "New Chat"
  #    end
  #  end
end
