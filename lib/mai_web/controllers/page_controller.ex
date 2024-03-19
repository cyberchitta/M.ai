defmodule MaiWeb.PageController do
  use MaiWeb, :controller

  import Mai.UiState

  plug :put_view, html: MaiWeb.Components.Webui

  def chat(conn, _params) do
    render(conn, :chat, create_assigns())
  end
end
