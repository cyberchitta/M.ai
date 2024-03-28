defmodule Mai.Chat.User do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field(:google_id, :string)
    field(:email, :string)
    field(:name, :string)
    field(:avatar_url, :string)

    has_many(:chats, Mai.Chat.Chat)

    timestamps()
  end
end
