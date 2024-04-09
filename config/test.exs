import Config

config :mai, MaiWeb.Endpoint, server: false

config :logger, level: :warning
config :phoenix, :plug_init_mode, :runtime

config :mai, Mai.RepoPostgres,
  database: "mai_chat_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10
