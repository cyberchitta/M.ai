defmodule Mai.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:order, :int)
      add(:role, :string)
      add(:content, :string)

      add(:chat_id, :binary_id)
      add(:original_message_id, :binary_id)

      timestamps()
    end
  end
end
