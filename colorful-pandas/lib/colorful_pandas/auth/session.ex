defmodule ColorfulPandas.Auth.Session do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Query

  alias ColorfulPandas.Auth.Identity
  alias ColorfulPandas.Auth.Session

  @token_size 32
  @token_validity_in_days 7

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "sessions" do
    field :token, :binary

    belongs_to :identity, ColorfulPandas.Auth.Identity

    timestamps updated_at: false
  end

  @type t :: %Session{
          id: integer(),
          token: binary(),
          identity: Identity.t() | Ecto.Association.NotLoaded.t()
        }

  @doc false
  def token_size, do: @token_size
  @doc false
  def token_validity_in_days, do: @token_validity_in_days

  @doc """
  Builds a session token.

  Generates a random token with length `@token_size` and associates it with the given identity.
  """
  @spec build(integer()) :: Session.t()
  def build(identity_id) do
    token = :crypto.strong_rand_bytes(@token_size)

    %Session{token: token, identity_id: identity_id}
  end

  @doc """
  Builds a query for fetching a token with the given token string.
  """
  @spec with_token_query(binary()) :: Ecto.Query.t()
  def with_token_query(token) do
    from(t in Session,
      where: t.token == ^token
    )
  end
end
