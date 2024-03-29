defmodule Mai.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:google_id, :string)
      add(:email, :string)
      add(:name, :string)
      add(:avatar_url, :string)

      timestamps()
    end
  end
end
