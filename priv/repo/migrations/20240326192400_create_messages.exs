defmodule Mai.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:role, :string)
      add(:content, :string)

      add(:chat_id, :uuid)
      add(:original_message_id, :uuid)

      timestamps()
    end
  end
end
