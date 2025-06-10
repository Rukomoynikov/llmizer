defmodule LlmizerWeb.ChatsListComponent do
  use Phoenix.Component
  use Gettext, backend: LlmizerWeb.Gettext

  def chats_list(assigns) do
    ~H"""
    <div class="bg-gray-100 rounded-lg">
      <div class="overflow-y-auto h-full p-2">
        <div class="pb-2 font-bold">Chats</div>
        <%= if @chats && Enum.any?(@chats) do %>
          <div>
            <%= for chat <- @chats do %>
                <.link href={"/chats/#{chat.id}"} class="block pb-0.5 p-1 hover:border-l-4 hover:border-sky-700 hover:bg-sky-100">{chat.name}</.link>
            <% end %>
          </div>
        <% else %>
          <p>No chats available.</p>
        <% end %>
      </div>
    </div>
    """
  end
end