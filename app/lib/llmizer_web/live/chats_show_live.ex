defmodule LlmizerWeb.ChatsShowLive do
  use LlmizerWeb, :live_view

  alias Llmizer.Chats

  @impl true
  def mount(%{"chat_id" => chat_id}, _session, socket) do
    chats = Chats.list_chats()
    chat = Chats.get_chat!(chat_id)

    {:ok,
     socket
     |> assign(:page_title, "#{chat.name}}")
     |> assign(:chats, chats)
     |> assign(:chat, chat)}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end
end
