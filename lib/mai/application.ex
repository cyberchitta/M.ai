defmodule Mai.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Mai.Repo,
      MaiWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:mai, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mai.PubSub},
      # Start a worker by calling: Mai.Worker.start_link(arg)
      # {Mai.Worker, arg},
      # Start to serve requests, typically the last entry
      MaiWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mai.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    MaiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
