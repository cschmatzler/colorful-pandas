defmodule ColorfulPandas.Fixtures.Auth do
  @moduledoc false

  use Boundary, check: [in: false, out: false]

  alias ColorfulPandas.Auth.SessionToken
  alias ColorfulPandas.Auth.User
  alias ColorfulPandas.Repo

  def setup_user(_context) do
    %{user: user_fixture()}
  end

  def setup_session(_context) do
    user = user_fixture()
    %{user: user, session_token: session_token_fixture(user)}
  end

  def user_fixture(attrs \\ %{}) do
    default_attrs = %{
      provider: "google",
      uid: make_ref() |> :erlang.ref_to_list() |> List.to_string(),
      email: "google_user@example.com",
      name: "Google User",
      image: "https://example.com/image.jpg"
    }

    attrs = Map.merge(default_attrs, attrs)

    %User{}
    |> User.changeset(attrs)
    |> Repo.insert!()
  end

  def session_token_fixture(
        user \\ user_fixture(),
        attrs \\ %{payload: :crypto.strong_rand_bytes(SessionToken.token_size())}
      ) do
    token = Repo.insert!(%SessionToken{payload: attrs.payload, user_id: user.id})

    token
  end
end
