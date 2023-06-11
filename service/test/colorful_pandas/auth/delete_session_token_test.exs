defmodule ColorfulPandas.Auth.DeleteSessionTokenTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  import ColorfulPandas.Fixtures.Auth
  import Ecto.Query

  alias ColorfulPandas.Auth.Impl, as: Auth
  alias ColorfulPandas.Auth.SessionToken

  describe "when token with given payload exists" do
    setup :setup_session

    test "deletes the token from the database", %{session_token: session_token} do
      assert :ok = Auth.delete_session_token(session_token.payload)

      assert Repo.aggregate(from(st in SessionToken, where: st.payload == ^session_token.payload), :count, :id) ==
               0
    end
  end

  describe "when no token with given payload exists" do
    test "returns :ok" do
      assert :ok = Auth.delete_session_token("invalid_session_token")
    end
  end
end
