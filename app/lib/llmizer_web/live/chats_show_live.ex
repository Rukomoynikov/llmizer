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
  def render(assigns) do
    ~H"""
    <div>Your chats</div>
    <div>
      <%= if @chat do %>
        {chat_messages(assigns)}
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp chat_messages(assigns) do
    ~H"""
    <div>
      <h2>{@chat.name}</h2>
      <ul>
        <%= for message <- @chat.chat_messages do %>
          <li><strong>{message.role}:</strong> {message.content}</li>
        <% end %>
      </ul>
    </div>
    """
  end
end
