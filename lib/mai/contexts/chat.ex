defmodule Mai.Contexts.Chat do
  @moduledoc false
  import Ecto.Query

  def get_chat_details(chat_id) do
    chat = Mai.RepoPostgres.get(Mai.Schemas.Chat, chat_id)

    messages =
      Mai.RepoPostgres.all(
        from(m in Mai.Schemas.Message,
          where: m.chat_id == ^chat_id,
          order_by: [asc: m.inserted_at]
        )
      )

    %{chat: chat, messages: messages}
  end
end
