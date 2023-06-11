defmodule ColorfulPandas.Auth.SignupFlow do
  @moduledoc false
  use Ecto.Schema

  # import Ecto.Changeset
  # import Ecto.Query

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "users" do
    field(:provider, :string)
    field(:uid, :string)
    field(:email, :string)
    field(:name, :string)
    timestamps()
  end
end
