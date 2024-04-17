defmodule Mai.Contexts.Message do
  def insert!(msg) do
    msg |> Mai.Schemas.Message.changeset() |> Mai.RepoPostgres.insert!()
  end

  def user(chat_id, turn_number, content) do
    msg(chat_id, turn_number, "user", content)
  end

  def assistant(chat_id, turn_number, content) do
    msg(chat_id, turn_number, "assistant", content)
  end

  def msg(chat_id, turn_number, role, content) do
    %{chat_id: chat_id, turn_number: turn_number, role: role, content: content}
  end
end
