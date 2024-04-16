defmodule MaiWeb.UiState do
  alias Mai.Contexts.Chat
  alias Mai.Contexts.User

  def get_index(user_id) do
    %{sidebar: sidebar(user_id), main: suggestions()}
  end

  def get_index(user_id, chat_id) do
    chat = Mai.Contexts.Chat.get_chat_details(chat_id)
    %{sidebar: sidebar(user_id), main: %{chat: chat}}
  end

  defp sidebar(user_id) do
    %{periods: Chat.list_chats_by_period(user_id), user: User.get_by_id(user_id)}
  end

  defp suggestions() do
    suggestions = Mai.Contexts.Suggestion.get_default()
    input_value = Enum.random(suggestions).title
    %{suggestions: suggestions, input_value: input_value}
  end
end
