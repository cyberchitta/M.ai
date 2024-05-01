defmodule MaiWeb.Router do
  use MaiWeb, :router

  import MaiWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MaiWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", MaiWeb do
    pipe_through :browser

    get "/auth/google/callback", GauthController, :callback
    get "/logout", GauthController, :logout

    live_session :user,
      on_mount: [{MaiWeb.UserAuth, :mount_user}] do
      live "/", ChatsLive, :index
    end
  end

  scope "/", MaiWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :authenticated,
      on_mount: [{MaiWeb.UserAuth, :ensure_authenticated}] do
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
