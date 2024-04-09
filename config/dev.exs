import Config

config :mai, MaiWeb.Endpoint,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:mai, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:mai, ~w(--watch)]}
  ]

config :mai, MaiWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/mai_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :mai, Mai.RepoPostgres,
  database: "mai_chat_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :mai, Mai.RepoXandra,
  sync_connect: 5000,
  log: :info,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :mai, dev_routes: true
config :logger, :console, format: "[$level] $message\n"
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
config :phoenix_live_view, :debug_heex_annotations, true
