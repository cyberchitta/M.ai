defmodule Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:order, :integer)
      add(:role, :string)
      add(:content, :string)
      add(:chat_id, references(:chats, type: :binary_id))
      add(:original_message_id, references(:messages, type: :binary_id))

      timestamps()
    end
  end
end
