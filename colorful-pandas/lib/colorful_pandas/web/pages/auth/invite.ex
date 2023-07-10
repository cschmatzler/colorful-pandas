defmodule ColorfulPandas.Web.Pages.Auth.Invite do
  @moduledoc false
  use ColorfulPandas.Web.Page, :controller

  alias ColorfulPandas.Auth
  alias ColorfulPandas.Auth.Invite

  def show(conn, params) do
    with token when not is_nil(token) <- Map.get(params, "token"),
         {:ok, decoded_token} <- CrockfordBase32.decode_to_binary(token),
         %Invite{} = invite <- Auth.get_invite_by_token(decoded_token, preload: [:organization, :created_by]) do
      conn
      |> put_session(:invite, invite.id)
      |> render(:show, invite: invite)
    else
      _ ->
        render(conn, :show)
    end
  end
end

defmodule ColorfulPandas.Web.Pages.Auth.InviteHTML do
  use ColorfulPandas.Web, :component

  alias ColorfulPandas.Auth

  embed_templates("invite/*")
end
