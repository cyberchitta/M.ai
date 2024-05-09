defmodule MaiWeb.Router do
  use MaiWeb, :router

  import MaiWeb.UserGauth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MaiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/", MaiWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/gauth", PageController, :gauth
  end

  scope "/", MaiWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/auth/google/callback", GauthController, :callback
  end

  scope "/", MaiWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/logout", GauthController, :logout

    live_session :authenticated,
      on_mount: [{MaiWeb.UserGauth, :ensure_authenticated}] do
      live "/chats", ChatsLive, :index
      live "/chats/:id", ChatsLive, :show
    end
  end

  if Application.compile_env(:mai, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MaiWeb.Telemetry
    end
  end
end
