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

  @type t :: %SignupFlow{
          id: integer(),
          provider: String.t(),
          uid: String.t(),
          email: String.t(),
          name: String.t(),
          invite: OrganizationInvite.t() | Ecto.Association.AssociationNotLoaded.t() | nil,
          invite_id: integer() | nil,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t() | nil
        }

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
