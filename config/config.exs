import Config

config :mai, Mai.Repo,
  migration_primary_key: [name: :id, type: :binary_id],
  contact_points: ["scylladb"],
  keyspace: "mai_chat",
  port: 9042

config :mai,
  generators: [timestamp_type: :utc_datetime]

config :mai, ecto_repos: [Mai.Repo]

config :mai, MaiWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: MaiWeb.ErrorHTML, json: MaiWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Mai.PubSub,
  live_view: [signing_salt: "zs6SQ7ka"]

config :esbuild,
  version: "0.17.11",
  mai: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.4.0",
  mai: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
