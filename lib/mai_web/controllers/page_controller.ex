# lib/mai_web/controllers/page_controller.ex
defmodule MaiWeb.PageController do
  alias MaiWeb.UserGauth
  use MaiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def gauth(conn, _params) do
    redirect(conn, external: UserGauth.gauth_url())
  end
end
