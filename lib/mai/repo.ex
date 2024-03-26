defmodule Mai.Repo do
  use Ecto.Repo,
    otp_app: :mai,
    adapter: Exandra
end
