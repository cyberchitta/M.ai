import Config
import Dotenvy

dir = System.get_env("RELEASE_ROOT") || "envs/"

source!([
  "#{dir}.#{config_env()}.env",
  "#{dir}.#{config_env()}.local.env",
  System.get_env()
])

if System.get_env("PHX_SERVER") do
  config :mai, MaiWeb.Endpoint, server: true
end

config :mai, MaiWeb.Endpoint, secret_key_base: env!("SECRET_KEY_BASE", :string)

config :mai, MaiWeb.Endpoint,
  http: [
    ip:
      env!("PHX_IP", fn ip ->
        ip
        |> String.split(",")
        |> Enum.map(&String.trim/1)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end),
    port: env!("PHX_PORT", :integer)
  ]

if config_env() == :prod do
  host = env!("PHX_HOST", :string, "example.com")

  config :mai, :dns_cluster_query, env!("DNS_CLUSTER_QUERY", :string?)

  config :mai, MaiWeb.Endpoint, url: [host: host, port: 443, scheme: "https"]
end

# ## SSL Support
#
# To get SSL working, you will need to add the `https` key
# to your endpoint configuration:
#
#     config :mai, MaiWeb.Endpoint,
#       https: [
#         ...,
#         port: 443,
#         cipher_suite: :strong,
#         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
#       ]
#
# The `cipher_suite` is set to `:strong` to support only the
# latest and more secure SSL ciphers. This means old browsers
# and clients may not be supported. You can set it to
# `:compatible` for wider support.
#
# `:keyfile` and `:certfile` expect an absolute path to the key
# and cert in disk or a relative path inside priv, for example
# "priv/ssl/server.key". For all supported SSL configuration
# options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
#
# We also recommend setting `force_ssl` in your config/prod.exs,
# ensuring no data is ever sent via http, always redirecting to https:
#
#     config :mai, MaiWeb.Endpoint,
#       force_ssl: [hsts: true]
#
# Check `Plug.SSL` for all available options in `force_ssl`.
