defmodule ColorfulPandas.Auth.Organization do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Organization
  alias ColorfulPandas.Auth.OrganizationInvite

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "organizations" do
    field :name, :string

    has_many :invites, OrganizationInvite
    has_many :members, Identity

    timestamps()
  end

  @doc """
  Builds a changeset for an organization.
  """
  @spec changeset(%Organization{}, map()) :: Ecto.Changeset.t()
  def changeset(%Organization{} = identity \\ %Organization{}, attrs) do
    identity
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
