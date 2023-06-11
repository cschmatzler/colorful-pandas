defmodule ColorfulPandas.Auth.GetUserWithSessionTokenTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  import ColorfulPandas.Fixtures.Auth

  alias ColorfulPandas.Auth.Impl, as: Auth
  alias ColorfulPandas.Auth.SessionToken

  describe "when token is valid and unexpired" do
    setup :setup_session

    test "returns the user belonging to the token", %{session_token: session_token, user: user} do
      assert user == Auth.get_user_with_session_token(session_token.payload)
    end
  end

  describe "when the token is invalid" do
    test "returns nil" do
      assert "invalid_token" |> Auth.get_user_with_session_token() |> is_nil()
    end
  end

  describe "when the token is valid, but expired" do
    setup :setup_session

    setup %{session_token: session_token} do
      expired_date =
        DateTime.utc_now()
        |> DateTime.add(-SessionToken.token_validity_in_days(), :day)
        |> DateTime.truncate(:second)

      expired_session_token = session_token |> Ecto.Changeset.change(inserted_at: expired_date) |> Repo.update!()

      %{session_token: expired_session_token}
    end

    test "returns nil", %{session_token: session_token} do
      assert session_token.payload |> Auth.get_user_with_session_token() |> is_nil()
    end
  end
end
