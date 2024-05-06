defmodule MaiWeb.UserAuth do
  @moduledoc false
  use MaiWeb, :verified_routes

  import Plug.Conn
  import Phoenix.Controller

  alias Mai.Contexts.User

  def gauth_url() do
    MaiWeb.Endpoint.url() |> ElixirAuthGoogle.generate_oauth_url()
  end

  def log_in_user(conn, user, _params \\ %{}) do
    conn |> renew_session() |> put_token_in_session(user.id)
  end

  defp renew_session(conn) do
    delete_csrf_token()
    conn |> configure_session(renew: true) |> clear_session()
  end

  def log_out_user(conn) do
    if live_socket_id = get_session(conn, :live_socket_id) do
      MaiWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn |> renew_session() |> redirect(to: ~p"/")
  end

  def fetch_current_user(conn, _opts) do
    user_id = get_session(conn, :user_id)
    conn |> assign(:user_id, user_id)
  end

  def on_mount(:mount_user, _params, session, socket) do
    {:cont, mount_user(socket, session)}
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    socket = mount_user(socket, session)

    if socket.assigns[:user_id] do
      {:cont, socket}
    else
      s =
        socket
        |> Phoenix.LiveView.put_flash(:error, "You must log in to access this page.")
        |> Phoenix.LiveView.redirect(to: ~p"/gauth")

      {:halt, s}
    end
  end

  def on_mount(:redirect_if_user_is_authenticated, _params, session, socket) do
    socket = mount_user(socket, session)

    if socket.assigns[:user_id] do
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_in_path(socket))}
    else
      {:cont, socket}
    end
  end

  defp mount_user(socket, session) do
    user_id = session["user_id"] |> IO.inspect()

    socket
    |> Phoenix.Component.assign(:user_id, user_id)
    |> Phoenix.Component.assign_new(:user, fn ->
      if user_id do
        User.get_by_id(user_id)
      end
    end)
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:user_id] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  def require_authenticated_user(conn, _opts) do
    if conn.assigns[:user_id] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: ~p"/gauth")
      |> halt()
    end
  end

  defp put_token_in_session(conn, token) do
    conn
    |> put_session(:user_id, token)
    |> put_session(:live_socket_id, "users_sessions:#{Base.url_encode64(token)}")
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(_conn), do: ~p"/"
end
