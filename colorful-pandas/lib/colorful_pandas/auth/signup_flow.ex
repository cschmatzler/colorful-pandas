defmodule ColorfulPandas.Auth.SignupFlow do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias ColorfulPandas.Auth.Invite
  alias ColorfulPandas.Auth.SignupFlow

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "signup_flows" do
    field :provider, :string
    field :uid, :string
    field :email, :string
    field :name, :string

    # If the `organization_name` field is present without an `Invite`, a new organization will be created
    # with the new account as its only member and administrator.
    # If both are present, the invite takes precedence and no new organization is created.
    field :organization_name, :string
    belongs_to :invite, Invite

    timestamps()
  end

  @type t :: %SignupFlow{
          id: integer(),
          provider: String.t(),
          uid: String.t(),
          email: String.t(),
          name: String.t(),
          invite: Invite.t() | Ecto.Association.AssociationNotLoaded.t() | nil,
          invite_id: integer() | nil,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t() | nil
        }

  @cast ~w(provider uid email name organization_name invite_id)a
  @required ~w(provider uid email name)a
  def changeset(%SignupFlow{} = signup_flow \\ %SignupFlow{}, attrs) do
    signup_flow
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> unsafe_validate_unique([:provider, :uid], ColorfulPandas.Repo)
    |> unique_constraint([:provider, :uid])
  end

  def with_oauth_query(provider, uid) do
    from(u in SignupFlow,
      where: u.provider == ^provider,
      where: u.uid == ^uid
    )
  end
end
