defmodule Mai.RepoXandra do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :mai,
    adapter: Exandra
end
