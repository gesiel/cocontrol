defmodule Cocontrol.Repo do
  use Ecto.Repo,
    otp_app: :cocontrol,
    adapter: Ecto.Adapters.Postgres
end
