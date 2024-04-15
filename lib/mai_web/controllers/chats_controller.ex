defmodule MaiWeb.ChatsController do
  use MaiWeb, :controller

  alias MaiWeb.UiState.Index

  plug :put_view, html: MaiWeb.Components.Webui

  @user_id "a4b22541-b2a5-46bf-b451-09c6d0c1d6f0"

  def index(conn, _params) do
    render(conn, :index, Index.get(@user_id))
  end

  def show(conn, %{"id" => chat_id}) do
    render(conn, :index, Index.get(@user_id, chat_id))
  end
end
