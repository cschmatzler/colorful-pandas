defmodule ColorfulPandas.Auth.SignupFlow do
  @moduledoc false
  use Ecto.Schema

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

  @spec with_oauth_query(String.t(), String.t()) :: Ecto.Query.t()
  def with_oauth_query(provider, uid) do
    from(u in SignupFlow,
      where: u.provider == ^provider,
      where: u.uid == ^uid
    )
  end
end
