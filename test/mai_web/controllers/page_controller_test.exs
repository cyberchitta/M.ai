defmodule MaiWeb.PageControllerTest do
  use MaiWeb.ConnCase

  setup tags do
    Mai.DataCase.setup_sandbox(tags)
    :ok
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/mai")

    assert html_response(conn, 200) =~
             "Please note: You will need to authenticate with Google to access the chat features."
  end
end
