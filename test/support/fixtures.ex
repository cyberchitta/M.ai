defmodule Mai.Fixtures do
  alias Mai.RepoPostgres
  alias Mai.Schemas.{User, Chat, Message}

  def create_user_data(user_attrs) do
    user =
      %User{}
      |> User.changeset(user_attrs)
      |> RepoPostgres.insert!()

    Enum.each(1..Enum.random(1..2), fn _ ->
      chat_attrs = %{
        name: "Chat #{Enum.random(1..100)}",
        description: "A chat for #{user.name}",
        user_id: user.id
      }

      chat =
        %Chat{}
        |> Chat.changeset(chat_attrs)
        |> RepoPostgres.insert!()

      Enum.each(1..Enum.random(3..5), fn order ->
        message_attrs = %{
          content: "Message #{order} for Chat #{chat.id}",
          role: if(rem(order, 2) == 0, do: "response", else: "request"),
          chat_id: chat.id
        }

        %Message{}
        |> Message.changeset(message_attrs)
        |> RepoPostgres.insert!()
      end)
    end)
  end

  def seed_data do
    users = [
      %{
        google_id: "user1_google_id",
        email: "user1@example.com",
        name: "User 1",
        avatar_url: "/images/user.png"
      },
      %{
        google_id: "user2_google_id",
        email: "user2@example.com",
        name: "User 2",
        avatar_url: "/images/user.png"
      }
    ]

    Enum.each(users, &create_user_data/1)
  end
end
