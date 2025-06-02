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

  @impl true
  def handle_event("validate", %{"chat_message" => chat_message_params}, socket) do
    changeset = new_chat_message_changeset()
    |> Map.put(:params, chat_message_params)

    {:noreply, assign(socket, :form, changeset)}
  end

  def handle_event("save", %{"chat_message" => chat_message_params}, socket) do
    case Chats.create_chat_message(chat_message_params) do
      {:ok, _chat_message} ->
        {:noreply, socket |> put_flash(:info, "Chat message created successfully.")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, changeset)}
    end
  end
end
