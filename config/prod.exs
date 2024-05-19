import Config

config :mai, MaiWeb.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :info

config :mai, Mai.RepoPostgres,
  pool_size: 2
