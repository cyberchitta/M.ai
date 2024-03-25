defmodule MaiWeb.PageController do
  use MaiWeb, :controller

  alias MaiWeb.UiState

  plug :put_view, html: MaiWeb.Components.Webui

  def chat(conn, _params) do
    render(conn, :index, UiState.Index.create_fixture())
  end
end
