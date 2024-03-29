defmodule Mai.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:description, :string)

      add(:user_id, :uuid)

      timestamps()
    end
  end
end
