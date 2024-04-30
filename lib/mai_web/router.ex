defmodule MaiWeb.Router do
  use MaiWeb, :router

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
    live "/", ChatsLive, :index
    live "/chats/:id", ChatsLive, :show
    get "/auth/google/callback", GauthController, :callback
    get "/logout", GauthController, :logout
  end

  if Application.compile_env(:mai, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MaiWeb.Telemetry
    end
  end
end
