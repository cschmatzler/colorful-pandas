defmodule ColorfulPandas.Auth.SessionToken do
  @moduledoc """
  A session token.
  """

  use Ecto.Schema

  import Ecto.Query

  alias ColorfulPandas.Auth.User

  @token_size 32
  @token_validity_in_days 7

  @schema_prefix "auth"
  @timestamps_opts [type: :utc_datetime]
  schema "session_tokens" do
    field(:payload, :binary)
    belongs_to(:user, ColorfulPandas.Auth.User)
    timestamps(updated_at: false)
  end

  @type t :: %__MODULE__{
          id: integer(),
          payload: binary(),
          user: User.t() | Ecto.Association.NotLoaded.t()
        }

  @doc false
  def token_size, do: @token_size
  @doc false
  def token_validity_in_days, do: @token_validity_in_days

  @doc """
  Builds a session token.

  Generates a random token with length `@token_size` and associates it with the given user.
  """
  @spec build(integer()) :: %__MODULE__{}
  def build(user_id) do
    payload = :crypto.strong_rand_bytes(@token_size)

    %__MODULE__{payload: payload, user_id: user_id}
  end

  @doc """
  Builds a query for fetching a token with the given token string.
  """
  @spec with_payload_query(binary()) :: Ecto.Query.t()
  def with_payload_query(payload) do
    from(t in __MODULE__,
      where: t.payload == ^payload
    )
  end

  @doc """
  Builds a query for fetching a user with the given token string.

  Only returns a user if the token has not expired, i.e. it has been created within the last
  `@session_validity_in_days` days.
  """
  def user_with_payload_query(payload) do
    from(t in __MODULE__,
      where: t.payload == ^payload,
      where: t.inserted_at >= ago(@token_validity_in_days, "day"),
      join: u in assoc(t, :user),
      select: u
    )
  end
end
