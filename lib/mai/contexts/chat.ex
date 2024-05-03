defmodule Mai.Contexts.Chat do
  @moduledoc false
  import Ecto.Query
  import Mai.RepoPostgres
  alias Mai.Schemas.{Chat, Message}

  def create(attrs) do
    Chat.changeset(attrs) |> insert!()
  end

  def user_msg(chat_id, turn_number, content) do
    msg(chat_id, turn_number, "user", content)
  end

  def assistant_msg(chat_id, turn_number, content) do
    msg(chat_id, turn_number, "assistant", content)
  end

  defp msg(chat_id, turn_number, role, content) do
    %{chat_id: chat_id, turn_number: turn_number, role: role, content: content}
  end

  def add_message!(chat_id, content, role, turn_number) do
    %{
      content: content,
      chat_id: chat_id,
      role: role,
      turn_number: turn_number
    }
    |> Message.changeset()
    |> insert!()
  end

  def details(chat_id) do
    chat = Chat |> get(chat_id)

    messages =
      from(m in Message,
        where: m.chat_id == ^chat_id,
        order_by: [asc: m.inserted_at]
      )
      |> all()

    %{chat: chat, messages: messages}
  end

  def list_by_period(user_id) do
    from(c in Chat,
      where: c.user_id == ^user_id,
      order_by: [desc: c.inserted_at],
      select: %{
        id: c.id,
        name: c.name,
        description: c.description,
        updated_at: c.updated_at
      }
    )
    |> all()
    |> Enum.map(fn chat -> Map.put(chat, :period, period_label(chat.updated_at)) end)
    |> Enum.group_by(& &1.period, &Map.take(&1, [:id, :name, :description, :updated_at]))
    |> Enum.map(fn {period, chats} -> %{label: period, chats: chats} end)
  end

  defp period_label(date) do
    today = Date.utc_today()
    yesterday = Date.add(today, -1)
    one_week_ago = Date.add(today, -7)
    one_month_ago = Date.add(today, -30)

    case true do
      _ when date >= today ->
        "Today"

      _ when date >= yesterday ->
        "Yesterday"

      _ when date >= one_week_ago ->
        "Previous 7 Days"

      _ when date >= one_month_ago ->
        "Previous 30 Days"

      _ ->
        month_name = Calendar.strftime(date, "%B")
        "#{month_name} #{date.year}"
    end
  end
end
