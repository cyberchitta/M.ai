defmodule Mai.Contexts.User do
  @moduledoc false
  import Ecto.Query

  def get_by_id(user_id) do
    Mai.RepoPostgres.get(Mai.Schemas.User, user_id)
  end

  def list_chats(user_id) do
    query =
      from(c in Mai.Schemas.Chat,
        where: c.user_id == ^user_id,
        select: %{id: c.id, name: c.name, description: c.description}
      )

    Mai.RepoPostgres.all(query)
  end
end
