defmodule Mai.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Mai.RepoPostgres,
      MaiWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:mai, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mai.PubSub},
      MaiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: Mai.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    MaiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
