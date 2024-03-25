defmodule MaiWeb.UiState.Index do
  alias MaiWeb.UiState

  def create_fixture() do
    %{sidebar: UiState.Sidebar.create_fixture(), start: UiState.Start.create_fixture()}
  end
end
