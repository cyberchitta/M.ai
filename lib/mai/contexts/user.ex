defmodule Mai.Contexts.User do
  @moduledoc false
  import Ecto.Query
  import Mai.RepoPostgres

  alias Mai.Schemas.{User, Chat}

  def get_by_id(user_id) do
    User |> get(user_id)
  end

  def validate(user_id) do
    case get_by_id(user_id) do
      nil -> {:error}
      user -> {:ok, user}
    end
  end

  def list_chats(user_id) do
    from(c in Chat,
      where: c.user_id == ^user_id,
      select: %{id: c.id, name: c.name, description: c.description}
    )
    |> all()
  end

  def upsert!(profile) do
    u =
      %{
        google_id: profile.sub,
        email: profile.email,
        name: profile.name,
        avatar_url: profile.picture
      }

    user = User |> get_by(email: profile.email)
    if user, do: user, else: %User{} |> User.changeset(u) |> insert!()
  end
end
