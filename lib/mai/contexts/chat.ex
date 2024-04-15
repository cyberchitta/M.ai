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

  def list_chats_by_period(user_id) do
    from(c in Mai.Schemas.Chat,
      where: c.user_id == ^user_id,
      order_by: [desc: c.inserted_at],
      select: %{
        id: c.id,
        name: c.name,
        description: c.description,
        updated_at: c.updated_at
      }
    )
    |> Mai.RepoPostgres.all()
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
