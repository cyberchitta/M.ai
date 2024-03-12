defmodule MaiWeb.PageController do
  use MaiWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
