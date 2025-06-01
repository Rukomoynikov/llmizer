defmodule Llmizer.Repo.Migrations.CreateChatMessages do
  use Ecto.Migration

  def change do
    create table(:chat_messages) do
      add :content, :text, null: false
      add :role, :string, null: false
      add :chat_id, references(:chats, on_delete: :delete_all), null: false

      timestamps()
    end
  end
end
