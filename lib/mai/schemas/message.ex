defmodule Mai.Schemas.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "messages" do
    field(:content, :string)
    field(:role, :string)

    belongs_to(:chat, Mai.Schemas.Chat, foreign_key: :chat_id, type: Ecto.UUID)

    belongs_to(:original_message, Mai.Schemas.Message,
      foreign_key: :original_message_id,
      type: Ecto.UUID
    )

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :role, :chat_id, :original_message_id])
    |> validate_required([:content, :role, :chat_id])
    |> validate_inclusion(:role, ["request", "response"])
    |> assoc_constraint(:chat)
    |> assoc_constraint(:original_message)
  end
end
