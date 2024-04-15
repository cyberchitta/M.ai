defmodule MaiWeb.UiState.Index do
  alias MaiWeb.UiState
  alias Mai.Contexts.Chat
  alias Mai.Contexts.User

  def create_fixture() do
    user_id = "a4b22541-b2a5-46bf-b451-09c6d0c1d6f0"

    %{
      sidebar: %{periods: Chat.list_chats_by_period(user_id), user: User.get_by_id(user_id)},
      main: UiState.Main.create_fixture()
    }
  end
end
