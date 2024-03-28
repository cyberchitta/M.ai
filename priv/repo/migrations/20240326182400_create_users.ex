defmodule Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:google_id, :string)
      add(:email, :string)
      add(:name, :string)
      add(:avatar_url, :string)

      timestamps()
    end

    create(unique_index(:users, [:google_id]))
    create(unique_index(:users, [:email]))
  end
end
