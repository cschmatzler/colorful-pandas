defmodule ColorfulPandas.Auth.GetUserWithOAuthTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  import ColorfulPandas.Fixtures.Auth

  alias ColorfulPandas.Auth.Impl, as: Auth

  describe "when identity exists" do
    setup :setup_identity

    test "returns the identity matching OAuth provider and UID", %{identity: identity} do
      assert identity == Auth.get_identity_with_oauth(identity.provider, identity.uid)
    end
  end

  describe "when identity does not exist" do
    test "returns nil" do
      assert "unknown" |> Auth.get_identity_with_oauth("0") |> is_nil()
    end
  end
end
