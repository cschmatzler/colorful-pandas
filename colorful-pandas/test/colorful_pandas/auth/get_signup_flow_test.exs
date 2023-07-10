defmodule ColorfulPandas.Auth.GetSignupFlowTest do
  use ColorfulPandas.DataCase, async: true
  use Hammox.Protect, module: ColorfulPandas.Auth.Impl, behaviour: ColorfulPandas.Auth

  alias ColorfulPandas.Auth

  describe "when no signup flow with that id exists" do
    test "returns nil" do
      refute Auth.get_signup_flow(1)
    end
  end
end
