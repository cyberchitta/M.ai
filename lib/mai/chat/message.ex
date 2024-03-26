defmodule Mai.Chat.Message do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "messages" do
    field(:content, :string)
    field(:role, :string)
    field(:order, :integer)

    belongs_to(:chat, Mai.Chat.Chat)
    belongs_to(:original_message, Mai.Chat.Message, foreign_key: :original_message_id, type: :binary_id)

    timestamps()
  end
end
