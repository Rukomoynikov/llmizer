defmodule Llmizer.Repo.Migrations.AddChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :name, :string, null: false

      timestamps()
    end
  end
end
