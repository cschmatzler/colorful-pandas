defmodule ColorfulPandas.Auth.CreateSessionTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  import ColorfulPandas.Fixtures.Auth

  alias ColorfulPandas.Auth.Impl, as: Auth
  alias ColorfulPandas.Auth.Session

  setup :setup_identity

  test "returns a session token", %{identity: identity} do
    assert %Session{} = Auth.create_session!(identity.id)
  end

  test "returns a struct with a random payload of fixed size", %{identity: identity} do
    session = Auth.create_session!(identity.id)

    assert byte_size(session.token) == Session.token_size()
  end

  test "returns a struct referencing the given identity id", %{identity: identity} do
    session = Auth.create_session!(identity.id)

    assert session.identity_id == identity.id
  end
end
