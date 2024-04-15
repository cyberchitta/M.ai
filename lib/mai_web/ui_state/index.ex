defmodule MaiWeb.UiState.Index do
  alias Mai.Contexts.Chat
  alias Mai.Contexts.User

  def create_fixture() do
    user_id = "a4b22541-b2a5-46bf-b451-09c6d0c1d6f0"

    user = User.get_by_id(user_id)
    periods = Chat.list_chats_by_period(user_id)

    suggestions = Mai.Contexts.Suggestion.get_default()
    input_value = Enum.random(suggestions).title
    chats = Mai.Contexts.User.list_chats(user_id)
    chat = Mai.Contexts.Chat.get_chat_details(List.first(chats).id)

    %{
      sidebar: %{periods: periods, user: user},
      main: %{chat: chat, suggestions: suggestions, input_value: input_value}
    }
  end
end
