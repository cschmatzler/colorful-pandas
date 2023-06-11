defmodule ColorfulPandas.Auth.CreateSessionsession_tokenTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  import ColorfulPandas.Fixtures.Auth

  alias ColorfulPandas.Auth.Impl, as: Auth
  alias ColorfulPandas.Auth.SessionToken

  setup :setup_user

  test "returns a session token", %{user: user} do
    assert %SessionToken{} = Auth.create_session_token!(user.id)
  end

  test "returns a struct with a random payload of fixed size", %{user: user} do
    session_token = Auth.create_session_token!(user.id)

    assert byte_size(session_token.payload) == SessionToken.token_size()
  end

  test "returns a struct referencing the given user id", %{user: user} do
    session_token = Auth.create_session_token!(user.id)

    assert session_token.user_id == user.id
  end
end
