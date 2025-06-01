defmodule Llmizer.Chats.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  alias Llmizer.Chats.ChatMessage

  schema "chats" do
    field :name, :string
    has_many :chat_messages, ChatMessage

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
