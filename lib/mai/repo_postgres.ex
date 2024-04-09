defmodule Mai.RepoPostgres do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :mai,
    adapter: Ecto.Adapters.Postgres
end
