defmodule MaiWeb.ChatsController do
  use MaiWeb, :controller

  alias MaiWeb.UiState

  plug :put_view, html: MaiWeb.Components.Webui

  def index(conn, _params) do
    render(conn, :index, UiState.Index.create_fixture())
  end

  def show(conn, %{"id" => id}) do
    render(conn, :index, UiState.Index.create_fixture())
  end
end
