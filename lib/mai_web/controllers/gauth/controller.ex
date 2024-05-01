defmodule MaiWeb.GauthController do
  use MaiWeb, :controller

  def callback(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGoogle.get_token(code, conn)
    {:ok, profile} = ElixirAuthGoogle.get_user_profile(token.access_token)
    user = Mai.Contexts.User.upsert!(profile)
    conn |> put_session(:user_id, user.id) |> render(:welcome, user: user)
  end

  def logout(conn, _params) do
    conn |> clear_session() |> redirect(to: "/")
  end
end
