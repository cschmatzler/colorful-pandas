defmodule ColorfulPandas.Web.Auth do
  @moduledoc """
  Authentication and authorization functionality for the web service.

  This module includes functions to fetch the current identity from a session, redirect identities based on their
  authentication status, manage session tokens, start and end identity sessions, and handle mount actions
  for authenticated LiveView components.

  The authentication process relies on session tokens stored in cookies.
  """

  use ColorfulPandas.Web, :verified_routes

  import Phoenix.Controller
  import Plug.Conn

  alias ColorfulPandas.Auth

  @session_cookie "session"
  @max_age 60 * 60 * 24 * 7
  @session_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc false
  def session_cookie, do: @session_cookie

  @doc "Path to redirect to when an authenticated session exists."
  # TODO: change this
  def signed_in_path, do: ~p"/"

  @doc "Path to redirect to when unauthenticated."
  def signed_out_path, do: ~p"/"

  def on_mount(:mount_user, _params, session, socket) do
    socket = mount_user(session, socket)

    {:cont, socket}
  end

  def on_mount(:require_session, _params, _session, socket) do
    if Map.get(socket.assigns, :user) do
      {:cont, socket}
    else
      {:halt, Phoenix.LiveView.redirect(socket, to: signed_out_path())}
    end
  end

  @doc "Adds a session token to the current session."
  def put_token_in_session(conn, token) do
    conn
    |> put_session(:session_token, token)
    |> put_session(:live_socket_id, "session_token:#{Base.url_encode64(token)}")
  end

  @doc """
  Creates a new authenticated session.

  Creates and persists a session token, which is then added to the browser session and stored as a
  session cookie. Afterwards, redirects to `signed_in_path/0`.
  """
  def start_session(conn, identity) do
    token = Auth.create_session!(identity.id).token

    conn
    |> renew_session()
    |> put_token_in_session(token)
    |> write_session_cookie(token)
    |> redirect(to: signed_in_path())
  end

  @doc """
  Ends an authenticated session, if one exists.

  Deletes the session token from the business layer, broadcasts a disconnect event to all
  connected LiveViews so that existing persistent connections are closed, preventing the
  identity from inadvertently staying authenticated.
  """
  def end_session(conn) do
    session = get_session(conn, :session)
    session && Auth.delete_session(session)

    if live_socket_id = get_session(conn, :live_socket_id) do
      ColorfulPandas.Web.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@session_cookie)
    |> redirect(to: signed_out_path())
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  defp write_session_cookie(conn, token) do
    put_resp_cookie(conn, @session_cookie, token, @session_options)
  end

  defp mount_user(session, socket) do
    case session do
      %{"session_token" => token} ->
        Phoenix.Component.assign_new(socket, :user, fn ->
          Auth.get_identity_with_session_token(token)
        end)

      %{} ->
        Phoenix.Component.assign_new(socket, :user, fn -> nil end)
    end
  end
end
