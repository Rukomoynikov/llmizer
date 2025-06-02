defmodule LlmizerWeb.ChatsLive do
  use LlmizerWeb, :live_view

  alias Llmizer.Chats
  alias LlmizerWeb.ChatFormComponent
  alias Llmizer.Chats.ChatMessage

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

  def mount(_params, _session, socket) do
    chats = Chats.list_chats()

    {:ok,
     socket
     |> assign(:page_title, "Home")
     |> assign(:chats, chats)
     |> assign(:chat, nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>Your chats</div>
    <.live_component module={ChatFormComponent} id="new_chat_form" form={new_chat_message_changeset()} />
    <div>
      <%= if @chats do %>
        {chats(assigns)}
      <% else %>
        <p>No chats available.</p>
      <% end %>
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

  defp chats(assigns) do
    ~H"""
    <ul>
      <%= for chat <- @chats do %>
        <li>{chat.name}</li>
      <% end %>
    </ul>
    """
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

  def handle_event("validate", %{"chat_message" => chat_message_params}, socket) do
    changeset = new_chat_message_changeset()
    |> Map.put(:params, chat_message_params)

    {:noreply, assign(socket, :form, changeset)}
  end

  def handle_event("save", %{"chat_message" => chat_message_params}, socket) do
    dbg(chat_message_params)
    case Chats.create_chat_message(chat_message_params) do
      {:ok, _chat_message} ->
        dbg(_chat_message)
        {:noreply, socket |> put_flash(:info, "Chat message created successfully.")}

      {:error, changeset} ->
        dbg(changeset)
        {:noreply, assign(socket, :form, changeset)}
    end
  end
end
