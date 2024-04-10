defmodule Mai.UserTest do
  use Mai.DataCase

  alias Mai.Contexts.User

  setup do
#    Mai.Fixtures.seed_data()
    :ok
  end

  test "list_chats/1 returns the chats for a user" do
    user = Mai.RepoPostgres.one(from(c in Mai.Schemas.User, limit: 1))
    # user = Mai.RepoPostgres.get_by(Mai.Schemas.User, email: "user1@example.com")
    chats = User.list_chats(user.id)

    assert length(chats) > 0
    assert Enum.all?(chats, fn chat -> chat.id != nil end)
    assert Enum.all?(chats, fn chat -> chat.name != nil end)
  end
end
