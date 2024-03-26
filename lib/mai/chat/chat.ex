defmodule Mai.Chat.Chat do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "chats" do
    field(:name, :string)
    field(:description, :string)

    belongs_to(:user, Mai.Chat.User)
    has_many(:messages, Mai.Chat.Message)

    timestamps()
  end
end
