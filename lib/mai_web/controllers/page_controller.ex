# lib/mai_web/controllers/page_controller.ex
defmodule MaiWeb.PageController do
  alias MaiWeb.UserAuth
  use MaiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def gauth(conn, _params) do
    redirect(conn, external: UserAuth.gauth_url())
  end
end
