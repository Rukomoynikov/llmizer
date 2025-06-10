defmodule LlmizerWeb.AddMessageFormComponent do
  use LlmizerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} phx-submit="save" phx-target={@myself} id="new-chat-form">
        <input type="hidden" name="chat_id" value={@form[:chat_id].value} />
        <.input field={@form[:content]} label="Message" />
        <:actions>
          <.button class="flex w-full justify-center rounded-md bg-indigo-600 px-3 py-1.5 text-sm/6 font-semibold text-white shadow-xs hover:bg-indigo-500 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event(
        "save",
        %{"chat_message" => %{"content" => content}, "chat_id" => chat_id},
        socket
      ) do
    case Llmizer.Chats.add_message_to_chat(chat_id, %{question: content}) do
      {:ok, chat} ->
        {:noreply,
         socket
         |> push_navigate(to: "/chats/#{chat.id}")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
