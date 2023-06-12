defmodule ColorfulPandas.Auth.SignupFlow do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias ColorfulPandas.Auth.OrganizationInvite
  alias ColorfulPandas.Auth.SignupFlow

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "signup_flows" do
    field :provider, :string
    field :uid, :string
    field :email, :string
    field :name, :string

    belongs_to :invite, OrganizationInvite

    timestamps()
  end

  @spec changeset(SignupFlow.t(), map()) :: Ecto.Changeset.t()
  def changeset(%SignupFlow{} = signup_flow \\ %SignupFlow{}, attrs) do
    signup_flow
    |> cast(attrs, [:provider, :uid, :email, :name, :invite_id])
    |> validate_required([:provider, :uid, :email, :name])
    |> unsafe_validate_unique([:provider, :uid], ColorfulPandas.Repo)
    |> unique_constraint([:provider, :uid])
  end

  @spec with_oauth_query(String.t(), String.t()) :: Ecto.Query.t()
  def with_oauth_query(provider, uid) do
    from(sf in SignupFlow,
      where: sf.provider == ^provider,
      where: sf.uid == ^uid
    )
  end
end
