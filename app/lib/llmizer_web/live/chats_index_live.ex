defmodule LlmizerWeb.ChatsIndexLive do
  use LlmizerWeb, :live_view

  alias Llmizer.Chats

  @impl true
  def mount(_params, _session, socket) do
    chats = Chats.list_chats()

    {:ok,
     socket
     |> assign(:page_title, "Home")
     |> assign(:chats, chats)
     |> assign(:form, new_chat_message_changeset())}
  end

  @impl true
  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp new_chat_message_changeset do
    attrs = %{
      content: "",
      name: "",
      role: "user",
      chat_id: nil
    }

    %Llmizer.Chats.ChatMessage{}
    |> Llmizer.Chats.ChatMessage.changeset(attrs)
    |> to_form()
  end
end
