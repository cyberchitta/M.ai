defmodule Mai.Schemas.Chat do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "chats" do
    field(:name, :string)
    field(:description, :string)

    belongs_to(:user, Mai.Schemas.User, foreign_key: :user_id, type: Ecto.UUID)
    has_many(:messages, Mai.Schemas.Message, foreign_key: :chat_id)

    timestamps()
  end

  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:name, :description, :user_id])
    |> validate_required([:name, :user_id])
    |> assoc_constraint(:user)
  end
end
