defmodule ColorfulPandas.Auth.OrganizationInvite do
  @moduledoc false
  use Ecto.Schema

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Organization

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "organization_invites" do
    field :token, :string

    belongs_to :created_by, Identity
    belongs_to :organization, Organization

    field :accepted_at, :utc_datetime
    timestamps updated_at: false
  end
end
