alias Mai.Repo
alias Mai.Chat.User
alias Mai.Chat.Chat
alias Mai.Chat.Message

# Create users
users = [
  %{google_id: "user1_google_id", email: "user1@example.com", name: "User 1", avatar_url: "/images/user.png"},
  %{google_id: "user2_google_id", email: "user2@example.com", name: "User 2", avatar_url: "/images/user.png"}
]

Enum.each(users, fn user_attrs ->
  %User{}
  |> User.changeset(user_attrs)
  |> Repo.insert!()
end)

# Fetch the created users
[user1, user2] = Repo.all(User)

# Create chats and messages for User 1
Enum.each(1..Enum.random(1..2), fn _ ->
  chat_attrs = %{name: "Chat #{Enum.random(1..100)}", description: "A chat for User 1", user_id: user1.id}
  chat = %Chat{}
  |> Chat.changeset(chat_attrs)
  |> Repo.insert!()

  Enum.each(1..Enum.random(3..5), fn order ->
    message_attrs = %{
      content: "Message #{order} for Chat #{chat.id}",
      role: if(rem(order, 2) == 0, do: "response", else: "request"),
      chat_id: chat.id
    }
    %Message{}
    |> Message.changeset(message_attrs)
    |> Repo.insert!()
  end)
end)

# Create chats and messages for User 2
Enum.each(1..Enum.random(1..2), fn _ ->
  chat_attrs = %{name: "Chat #{Enum.random(1..100)}", description: "A chat for User 2", user_id: user2.id}
  chat = %Chat{}
  |> Chat.changeset(chat_attrs)
  |> Repo.insert!()

  Enum.each(1..Enum.random(3..5), fn order ->
    message_attrs = %{
      content: "Message #{order} for Chat #{chat.id}",
      role: if(rem(order, 2) == 0, do: "response", else: "request"),
      chat_id: chat.id
    }
    %Message{}
    |> Message.changeset(message_attrs)
    |> Repo.insert!()
  end)
end)
