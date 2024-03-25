defmodule MaiWeb.UiState.Suggestions do
  def create_fixture() do
    [
      %{
        title: "Write a message",
        description: "that goes with a kitten gif for a friend on a rough day"
      },
      %{title: "Suggest fun activities", description: "for a family visiting San Francisco"},
      %{
        title: "Explain why popcorn pops",
        description: "to a kid who loves watching it in the microwave"
      },
      %{
        title: "Brainstorm edge cases",
        description: "for a function with birthdate as input, horoscope as output"
      }
    ]
  end
end
