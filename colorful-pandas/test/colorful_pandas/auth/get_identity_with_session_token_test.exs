defmodule ColorfulPandas.Auth.GetUserWithSessionTokenTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  import ColorfulPandas.Fixtures.Auth

  alias ColorfulPandas.Auth.Impl, as: Auth
  alias ColorfulPandas.Auth.Session

  describe "when token is valid and unexpired" do
    setup :setup_session

    test "returns the identity belonging to the token", %{session: session, identity: identity} do
      assert identity == Auth.get_identity_with_session_token(session.token)
    end
  end

  describe "when the token is invalid" do
    test "returns nil" do
      assert "invalid_token" |> Auth.get_identity_with_session_token() |> is_nil()
    end
  end

  describe "when the token is valid, but expired" do
    setup :setup_session

    setup %{session: session} do
      expired_date =
        DateTime.utc_now()
        |> DateTime.add(-Session.token_validity_in_days(), :day)
        |> DateTime.truncate(:second)

      expired_session = session |> Ecto.Changeset.change(inserted_at: expired_date) |> Repo.update!()

      %{session: expired_session}
    end

    test "returns nil", %{session: session} do
      assert session.token |> Auth.get_identity_with_session_token() |> is_nil()
    end
  end
end
