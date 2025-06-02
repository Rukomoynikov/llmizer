defmodule LlmizerWeb.ChatFormComponent do
  use LlmizerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2>New Chat Message</h2>
      <.simple_form
        for={@form}
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
        id="new-chat-form"
      >
        <.input field={@form[:content]} label="Message" />
        <button>Save</button>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"chat_message" => chat_message_params}, socket) do
    changeset =
      %Llmizer.Chats.ChatMessage{}
      |> Llmizer.Chats.ChatMessage.changeset(chat_message_params)
      |> to_form()

    {:noreply, assign(socket, :form, changeset)}
  end

  @impl true
  def handle_event("save", %{"chat_message" => %{"content" => content}}, socket) do
    case Llmizer.Chats.create_new_chat(%{question: content}) do
      {:ok, chat} ->
        {:noreply,
         socket
         |> push_navigate(to: "/chats/#{chat.id}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
