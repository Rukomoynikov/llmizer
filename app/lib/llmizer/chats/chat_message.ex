defmodule Llmizer.Chats.ChatMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "chat_messages" do
    field :content, :string
    field :role, :string
    belongs_to :chat, Llmizer.Chats.Chat

    timestamps()
  end

  @doc false
  def changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:content, :role, :chat_id])
    |> validate_required([:content, :role, :chat_id])
  end
end
