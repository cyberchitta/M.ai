defmodule MaiWeb.UiState.Index do
  alias Mai.Contexts.Chat
  alias Mai.Contexts.User

  def get(user_id) do
    user = User.get_by_id(user_id)
    periods = Chat.list_chats_by_period(user_id)

    suggestions = Mai.Contexts.Suggestion.get_default()
    input_value = Enum.random(suggestions).title

    %{
      sidebar: %{periods: periods, user: user},
      main: %{suggestions: suggestions, input_value: input_value}
    }
  end

  def get(user_id, chat_id) do
    chat = Mai.Contexts.Chat.get_chat_details(chat_id)
    index = get(user_id)
    %{index | main: Map.put(index.main, :chat, chat)}
  end
end
