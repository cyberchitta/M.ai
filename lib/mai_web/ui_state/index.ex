defmodule MaiWeb.UiState.Index do
  alias MaiWeb.UiState

  def create_fixture() do
    %{sidebar: UiState.Sidebar.create_fixture(), main: UiState.Main.create_fixture()}
  end
end
