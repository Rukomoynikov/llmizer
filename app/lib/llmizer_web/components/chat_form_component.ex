defmodule LlmizerWeb.ChatFormComponent do
  use LlmizerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h2 class="text-base/7 font-semibold text-gray-900">New chat message</h2>
      <p class="mt-0 mb-0 text-gray-600">Please add title and your question to start new chat with AI :)</p>

      <.simple_form
        for={@form}
        phx-change="validate"
        phx-submit="save"
        phx-target={@myself}
        id="new-chat-form"
      >
        <.input field={@form[:name]} label="Title" />
        <.input field={@form[:content]} label="Question" type="textarea" />
        <:actions>
          <.button class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Save</.button>
        </:actions>
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
  def handle_event("save", %{"chat_message" => %{"content" => content, "name" => name}}, socket) do
    case Llmizer.Chats.create_new_chat(%{question: content, name: name}) do
      {:ok, chat} ->
        {:noreply,
         socket
         |> push_navigate(to: "/chats/#{chat.id}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
