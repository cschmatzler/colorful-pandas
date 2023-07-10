defmodule ColorfulPandas.Auth.Organization do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Organization
  alias ColorfulPandas.Auth.Invite

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "organizations" do
    field :name, :string

    has_many :invites, Invite
    has_many :members, Identity

    timestamps()
  end

  @type t :: %Organization{
          name: String.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t() | nil
        }

  @doc """
  Builds a changeset for an organization.
  """
  @cast ~w(name)a
  @required ~w(name)a
  def changeset(%Organization{} = organization \\ %Organization{}, attrs) do
    organization
    |> cast(attrs, @cast)
    |> validate_required(@required)
  end
end
