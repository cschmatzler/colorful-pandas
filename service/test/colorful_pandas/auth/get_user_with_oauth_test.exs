defmodule ColorfulPandas.Auth.GetUserWithOAuthTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  import ColorfulPandas.Fixtures.Auth

  alias ColorfulPandas.Auth.Impl, as: Auth

  describe "when user exists" do
    setup :setup_user

    test "returns the user matching OAuth provider and UID", %{user: user} do
      assert user == Auth.get_user_with_oauth(user.provider, user.uid)
    end
  end

  describe "when user does not exist" do
    test "returns nil" do
      assert "unknown" |> Auth.get_user_with_oauth("0") |> is_nil()
    end
  end
end
