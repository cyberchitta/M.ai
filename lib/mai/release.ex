defmodule Mai.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :mai

  def create_database do
    load_app()

    config = Mai.RepoPostgres.config()

    case Ecto.Adapters.Postgres.storage_status(config) do
      :up ->
        IO.puts("Database #{config[:database]} already exists")

      :down ->
        IO.puts("Database #{config[:database]} does not exist. Creating...")

        case Ecto.Adapters.Postgres.storage_up(config) do
          :ok -> IO.puts("Database #{config[:database]} created successfully")
          {:error, reason} -> IO.puts("Failed to create database: #{inspect(reason)}")
        end

      {:error, _} = err ->
        IO.inspect(err, label: "Error checking database status")
    end
  end

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
