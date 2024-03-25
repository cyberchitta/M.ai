defmodule MaiWeb.UiState.Sidebar do
  alias MaiWeb.UiState

  def create_fixture() do
    yesterday =
      UiState.TimePeriod.create("Yesterday", [
        UiState.Chat.create_summary(0, "AI Assistant Budget Planning")
      ])

    %{
      chats: [],
      time_periods: [yesterday],
      current_user: %{name: "You", avatar_url: "/images/user.png"}
    }
  end
end
