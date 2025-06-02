defmodule LlmizerWeb.ChatsIndexLive do
  use LlmizerWeb, :live_view

  alias Llmizer.Chats
  alias LlmizerWeb.ChatFormComponent

  @impl true
  def mount(_params, _session, socket) do
    chats = Chats.list_chats()

    {:ok,
     socket
     |> assign(:page_title, "Home")
     |> assign(:chats, chats)
     |> assign(:chat, nil)
     |> assign(:form, new_chat_message_changeset())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>Your chats</div>
    <.live_component module={ChatFormComponent} id="new_chat_form" form={@form} />
    <div>
      <%= if @chats && Enum.any?(@chats) do %>
        <ul>
          <%= for chat <- @chats do %>
            <li>{chat.name}</li>
          <% end %>
        </ul>
      <% else %>
        <p>No chats available.</p>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp new_chat_message_changeset do
    attrs = %{
      content: "",
      role: "user",
      chat_id: nil
    }

    %Llmizer.Chats.ChatMessage{}
    |> Llmizer.Chats.ChatMessage.changeset(attrs)
    |> to_form()
  end
end
