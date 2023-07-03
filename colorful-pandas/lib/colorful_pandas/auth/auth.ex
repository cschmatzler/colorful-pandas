defmodule ColorfulPandas.Auth do
  @moduledoc """
  Aggregate for authentication and authorization.

  Login and signup are handled by using external OAuth providers.
  The following providers are supported:
    - GitHub

  For session persistence, tokens are used.

  The default implementation lives in `ColorfulPandas.Auth.Implementation`.
  """

  use Boundary, deps: [ColorfulPandas.Repo], exports: [Identity], top_level?: true

  use Knigge,
    otp_app: :template,
    default: ColorfulPandas.Auth.Impl

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Sessions
  alias ColorfulPandas.Auth.SignupFlow

  @callback get_signup_flow(id :: non_neg_integer()) :: SignupFlow.t() | nil

  @callback get_signup_flow_with_oauth(provider :: String.t(), uid :: String.t()) :: SignupFlow.t() | nil

  @doc """
  Fetches a identity with OAuth provider and external UID.

  Returns `nil` if no identity is found.
  """
  @callback get_identity_with_oauth(provider :: String.t(), uid :: String.t()) :: Identity.t() | nil

  @doc """
  Fetches a identity with a session token.

  Returns `nil` if the token does not exist or is expired.
  """
  @callback get_identity_with_session_token(token :: binary()) :: Identity.t() | nil

  # TODO:
  @doc """
  Creates a new signup flow.
  """

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

  @doc """
  Creates a new identity.
  """
  @callback create_identity(
              provider :: String.t(),
              uid :: String.t(),
              email :: String.t(),
              name :: String.t(),
              image_url :: String.t() | nil
            ) ::
              {:ok, Identity.t()} | {:error, Ecto.Changeset.t()}

  @doc """
  Creates a new session token for a identity.
  """
  @callback create_session!(identity_id :: integer()) :: Sessions.t()

  @doc """
  Deletes a session token.
  """
  @callback delete_session(token :: binary()) :: :ok
end
