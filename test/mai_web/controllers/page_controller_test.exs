defmodule MaiWeb.PageControllerTest do
  use MaiWeb.ConnCase

  setup tags do
    Mai.DataCase.setup_sandbox(tags)
    :ok
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")

    assert html_response(conn, 200) =~
             "LLMs can make mistakes. Consider checking important information."
  end
end
