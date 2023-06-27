defmodule ColorfulPandas.Auth.DeleteSessionTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  import ColorfulPandas.Fixtures.Auth
  import Ecto.Query

  alias ColorfulPandas.Auth.Impl, as: Auth
  alias ColorfulPandas.Auth.Session

  describe "when token with given payload exists" do
    setup :setup_session

    test "deletes the token from the database", %{session: session} do
      assert :ok = Auth.delete_session(session.token)

      assert Repo.aggregate(from(st in Session, where: st.token == ^session.token), :count, :id) == 0
    end
  end

  describe "when no token with given payload exists" do
    test "returns :ok" do
      assert :ok = Auth.delete_session("invalid_session")
    end
  end
end
