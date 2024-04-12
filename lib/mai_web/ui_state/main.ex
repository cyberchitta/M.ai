defmodule MaiWeb.UiState.Main do
  alias MaiWeb.UiState

  def create_fixture() do
    suggestions = UiState.Suggestions.create_fixture()
    input_value = Enum.random(suggestions) |> UiState.Input.create()
    chat = UiState.Chat.get_chat("")

    %{
      chat: chat,
      suggestions: suggestions,
      input_value: input_value
    }
  end
end
