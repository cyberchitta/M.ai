defmodule MaiWeb.UiState.Main do
  alias MaiWeb.UiState

  def create_fixture() do
    user_id = "a4b22541-b2a5-46bf-b451-09c6d0c1d6f0"
    suggestions = UiState.Suggestions.create_fixture()
    input_value = Enum.random(suggestions) |> UiState.Input.create()
    chats = Mai.Contexts.User.list_chats(user_id)
    chat = Mai.Contexts.Chat.get_chat_details(List.first(chats).id)

    %{
      chat: chat,
      suggestions: suggestions,
      input_value: input_value
    }
  end
end
