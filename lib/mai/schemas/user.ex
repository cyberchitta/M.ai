defmodule Mai.Schemas.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users" do
    field(:google_id, :string)
    field(:email, :string)
    field(:name, :string)
    field(:avatar_url, :string)

    has_many(:chats, Mai.Schemas.Chat, foreign_key: :user_id)

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:id, :google_id, :email, :name, :avatar_url])
    |> validate_required([:google_id, :email, :name])
    |> unique_constraint(:google_id)
    |> unique_constraint(:email)
  end
end
