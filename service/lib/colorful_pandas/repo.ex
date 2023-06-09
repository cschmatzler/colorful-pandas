defmodule ColorfulPandas.Repo do
  @moduledoc false

  use Boundary, top_level?: true

  use Ecto.Repo,
    otp_app: :colorful_pandas,
    adapter: Ecto.Adapters.Postgres
end
