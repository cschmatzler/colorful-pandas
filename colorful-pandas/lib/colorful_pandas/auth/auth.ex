defmodule ColorfulPandas.Auth do
  # TODO: Documentation
  @moduledoc false

  use Knigge,
    otp_app: :template,
    default: ColorfulPandas.Auth.Impl

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Organization
  alias ColorfulPandas.Auth.Sessions
  alias ColorfulPandas.Auth.SignupFlow

  # Signup
  # ------
  @callback get_signup_flow(id :: non_neg_integer(), opts: keyword()) :: SignupFlow.t() | nil

  @callback get_signup_flow_with_oauth(provider :: String.t(), uid :: String.t()) :: SignupFlow.t() | nil

  @callback create_signup_flow(
              oauth_provider :: String.t(),
              uid :: String.t(),
              email :: String.t(),
              name :: String.t() | nil
            ) :: {:ok, SignupFlow.t()} | {:error, Ecto.Changeset.t()}

  @callback create_signup_flow(
              oauth_provider :: String.t(),
              uid :: String.t(),
              email :: String.t(),
              name :: String.t() | nil,
              invite_id :: binary()
            ) :: {:ok, SignupFlow.t()} | {:error, Ecto.Changeset.t()}

  @callback update_signup_flow(flow :: SignupFlow.t(), changes :: map()) ::
              {:ok, SignupFlow.t()} | {:error, Ecto.Changeset.t()}

  # OrganizationInvite
  # ------------
  @callback get_organization_invite_by_token(token :: binary(), opts :: keyword()) :: OrganizationInvite.t() | nil

  @callback create_organization_invite(organization :: Organization.t(), created_by :: Identity.t()) ::
              {:ok, OrganizationInvite.t()} | {:error, Ecto.Changeset.t()}

  # Organization
  # ------------
  @callback list_organizations() :: list(Organization.t())

  # Identity
  # --------
  @callback get_identity_with_oauth(provider :: String.t(), uid :: String.t()) :: Identity.t() | nil

  @callback get_identity_with_session_token(token :: binary()) :: Identity.t() | nil

  @callback create_identity_from_flow(flow :: SignupFlow.t()) :: {:ok, Identity.t()} | {:error, Ecto.Changeset.t()}

  # Session
  # -------
  @callback create_session!(identity_id :: integer()) :: Sessions.t()

  @callback delete_session(token :: binary()) :: :ok
end
