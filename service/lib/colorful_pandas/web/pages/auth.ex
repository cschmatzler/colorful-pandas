defmodule ColorfulPandas.Web.Pages.Auth do
  @moduledoc """
  Web authentication controller.

  Starts OAuth requests, handles callbacks and manages session tokens.
  """

  use ColorfulPandas.Web, :controller

  alias ColorfulPandas.Auth

  plug(Ueberauth)

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
    |> redirect(to: ColorfulPandas.Web.Auth.signed_out_path())
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

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case Auth.get_user_with_oauth(auth.provider, auth.uid) do
      nil ->
        signup_flow = Auth.create_signup_flow(auth.provider, auth.uid, auth.info.email)
        redirect(conn, to: ~p"/auth/signup?flow=#{signup_flow.id}")

      %Auth.User{} = user ->
        ColorfulPandas.Web.Auth.start_session(conn, user)
    end
  end

  @doc """
  Ends an authenticated session.
  """
  def logout(conn, _params) do
    ColorfulPandas.Web.Auth.end_session(conn)
  end
end
