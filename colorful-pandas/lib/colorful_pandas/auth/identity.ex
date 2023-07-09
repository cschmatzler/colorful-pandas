defmodule ColorfulPandas.Auth.Identity do
  @moduledoc """
  Model for a identity.

  Since we are exclusively using OAuth, this is a dumb copy of whatever information the external
  provider is giving us. There won't be any identityname/email and password authentication, allowing
  us a great deal of simplification.

  As of right now, a identity model is never updated, even when parameters change on the side of the
  OAuth provider. This should be strongly reconsidered in the future, since, for example, email
  address changes can result in deliverability being broken.
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Organization
  alias ColorfulPandas.Auth.Session

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "identities" do
    field :provider, :string
    field :uid, :string
    field :email, :string
    field :name, :string
    field :image_url, :string
    field :role, Ecto.Enum, values: [:user, :admin], default: :user

    belongs_to :organization, Organization

    timestamps()
  end

  @type roles :: :user | :admin

  @type t :: %Identity{
          id: integer(),
          provider: String.t(),
          uid: String.t(),
          email: String.t(),
          name: String.t(),
          image_url: String.t() | nil,
          role: roles()
        }

  @doc """
  Builds a changeset for a identity.
  """
  @cast ~w(provider uid email name image_url role organization_id)a
  @required ~w(provider uid email name organization_id)a
  def changeset(%Identity{} = identity \\ %Identity{}, attrs) do
    identity
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> unsafe_validate_unique([:provider, :uid], ColorfulPandas.Repo)
    |> unique_constraint([:provider, :uid])
  end

  @doc """
  Builds a query for fetching a identity with OAuth provider and external UID.
  """
  @spec with_oauth_query(String.t(), String.t()) :: Ecto.Query.t()
  def with_oauth_query(provider, uid) do
    from(u in Identity,
      where: u.provider == ^provider,
      where: u.uid == ^uid
    )
  end

  @doc """
  """
  def with_session_token_query(token) do
    from(t in Session,
      where: t.token == ^token,
      where: t.inserted_at >= ago(^Session.token_validity_in_days, "day"),
      join: u in assoc(t, :identity),
      select: u
    )
  end
end
