defmodule ColorfulPandas.Web.Pages.Auth.Invite do
  @moduledoc false
  use ColorfulPandas.Web.Page, :controller

  alias ColorfulPandas.Auth
  alias ColorfulPandas.Auth.OrganizationInvite

  def show(conn, params) do
    with token when not is_nil(token) <- Map.get(params, "token"),
         {:ok, decoded_token} <- CrockfordBase32.decode_to_binary(token),
         %OrganizationInvite{} = invite <- Auth.get_organization_invite_by_token(decoded_token, preload: [:organization, :created_by]) do
      render(conn, :show, invite: invite)
    else
      _ ->
        render(conn, :show)
    end
  end
end

defmodule ColorfulPandas.Web.Pages.Auth.InviteHTML do
  use ColorfulPandas.Web, :component

  embed_templates("invite/*")
end
