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
     |> assign(:chat, chat)
     |> assign(:form, new_chat_message_changeset(chat))}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp new_chat_message_changeset(chat) do
    attrs = %{
      content: "",
      role: "user",
      chat_id: chat.id
    }

    %Llmizer.Chats.ChatMessage{}
    |> Llmizer.Chats.ChatMessage.changeset(attrs)
    |> to_form()
  end
end
