defmodule MaiWeb.UiState.Start do
  alias MaiWeb.UiState

  def create_fixture() do
    suggestions = UiState.Suggestions.create_fixture()
    input_value = Enum.random(suggestions) |> UiState.Input.create()

    %{
      suggestions: suggestions,
      input_value: input_value
    }
  end
end
