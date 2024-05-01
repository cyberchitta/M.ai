defmodule Mai.Contexts.User do
  @moduledoc false
  import Ecto.Query

  alias Mai.Schemas.User

  def get_by_id(user_id) do
    Mai.RepoPostgres.get(Mai.Schemas.User, user_id)
  end

  def list_chats(user_id) do
    from(c in Mai.Schemas.Chat,
      where: c.user_id == ^user_id,
      select: %{id: c.id, name: c.name, description: c.description}
    )
    |> Mai.RepoPostgres.all()
  end

  def upsert!(profile) do
    u = %{
      google_id: profile.sub,
      email: profile.email,
      name: profile.name,
      avatar_url: profile.picture
    }

    case Mai.RepoPostgres.get_by(User, email: profile.email) do
      nil ->
        u |> User.changeset() |> Mai.RepoPostgres.insert!()

      user ->
        user
        |> Map.from_struct()
        |> Map.merge(u)
        |> User.changeset()
        |> Mai.RepoPostgres.update!()
    end
  end
end
