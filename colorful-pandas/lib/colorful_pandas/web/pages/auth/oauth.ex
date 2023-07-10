defmodule ColorfulPandas.Web.Pages.Auth.OAuth do
  @moduledoc """
  Web authentication controller.

  Starts OAuth requests, handles callbacks and manages session tokens.
  """

  use ColorfulPandas.Web.Page, :controller

  alias ColorfulPandas.Auth
  alias ColorfulPandas.Web.Auth, as: WebAuth

  plug Ueberauth

  @doc """
  Starts an OAuth request.

  The general handling is provided by Ueberauth by calling `plug Ueberauth`.
  Ueberauth currently does not gracefully handle unknown providers, so we are adding an extra
  function clause here that matches on any provider - if the requested provider wasn't matched by
  Ueberauth before, an error is returned.
  """
  def request(conn, _params) do
    conn
    |> put_flash(:login_error, true)
    |> redirect(to: WebAuth.signed_out_path())
  end

  @doc """
  Handles an OAuth callback.

  Outcome of the OAuth request is handled by Ueberauth. The two function clauses of this handler
  are matching on Ueberauth's results and whether `ueberauth_failure` or `ueberauth_auth` is
  present in the connection.
  """
  def callback(conn, params)

  def callback(%{assigns: %{ueberauth_failure: _failure}} = conn, _params) do
    conn
    |> put_flash(:login_error, true)
    |> redirect(to: ColorfulPandas.Web.Auth.signed_out_path())
  end

  def callback(conn, _params) do
    %{assigns: %{ueberauth_auth: %{provider: provider, uid: uid} = auth}} = conn

    case Auth.get_identity_with_oauth(to_string(provider), to_string(uid)) do
      %Auth.Identity{} = identity ->
        WebAuth.start_session(conn, identity)

      nil ->
        redirect_to_signup_flow(conn, auth)
    end
  end

  defp redirect_to_signup_flow(conn, auth) do
    %{provider: provider, uid: uid, info: %{email: email, name: name}} = auth
    invite_id = get_session(conn, :invite)

    signup_flow =
      case Auth.get_signup_flow_with_oauth(to_string(provider), to_string(uid)) do
        %Auth.SignupFlow{} = signup_flow ->
          {:ok, signup_flow} = Auth.update_signup_flow(signup_flow, %{invite_id: invite_id || signup_flow.invite_id})
          signup_flow

        nil ->
          # TODO: Error handling
          {:ok, signup_flow} = Auth.create_signup_flow(to_string(provider), to_string(uid), email, name, invite_id)
          signup_flow
      end

    conn
    |> put_session(:flow_id, signup_flow.id)
    |> redirect(to: ~p"/auth/signup/details")
  end
end
