defmodule MaiWeb.GauthControllerTest do
  use MaiWeb.ConnCase

  setup tags do
    Mai.DataCase.setup_sandbox(tags)
    :ok
  end

  test "google_handler/2 for google auth callback", %{conn: conn} do
    conn = get(conn, "/auth/google/callback", %{code: "234"})
    assert html_response(conn, 200) =~ "nelson@gmail.com"
  end
end
