defmodule Mai.ChatTest do
  use Mai.DataCase

  alias Mai.Contexts.Chat

  setup do
#    Mai.Fixtures.seed_data()
    :ok
  end

  test "get_chat_details/1 returns the chat details and messages" do
    chat = Mai.RepoPostgres.one(from(c in Mai.Schemas.Chat, limit: 1))
    chat_details = Chat.get_chat_details(chat.id)

    assert chat_details.chat.id == chat.id
    assert chat_details.chat.name != nil
    assert chat_details.chat.description != nil
    assert chat_details.chat.user_id != nil

    assert length(chat_details.messages) > 0
    assert Enum.all?(chat_details.messages, fn message -> message.id != nil end)
    assert Enum.all?(chat_details.messages, fn message -> message.role != nil end)
    assert Enum.all?(chat_details.messages, fn message -> message.content != nil end)
    assert Enum.all?(chat_details.messages, fn message -> message.inserted_at != nil end)
  end
end
