import Config

config :mai, MaiWeb.Endpoint, server: false

config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime

config :mai, Mai.RepoPostgres,
  database: "mai_chat_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :elixir_auth_google,
  client_id: "631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt.apps.googleusercontent.com",
  client_secret: "MHxv6-RGF5nheXnxh1b0LNDq",
  httpoison_mock: true
