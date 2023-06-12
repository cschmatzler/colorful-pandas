defmodule ColorfulPandas.Web.Plugs.Auth do
  @moduledoc false
  import ColorfulPandas.Web.Auth, only: [signed_in_path: 0, signed_out_path: 0, session_cookie: 0]
  import Phoenix.Controller
  import Plug.Conn

  alias ColorfulPandas.Auth

  @doc """
  Reads the session token from the browser session or cookies, whichever is available, and, if the
  token is valid, assigns the corresponding identity to the connection.

  ## Usage
      # Router
      plug :fetch_identity
  """
  def fetch_identity(conn, _opts) do
    {session_token, conn} = ensure_session_token(conn)
    identity = session_token && Auth.get_identity_with_session_token(session_token)

    assign(conn, :identity, identity)
  end

  @doc """
  Redirects the connection to `signed_out_path/0` if no authenticated session exists.

  ## Usage
      # Router
      plug :require_session
  """
  def require_session(conn, _opts) do
    if conn.assigns[:identity] do
      conn
    else
      conn
      |> redirect(to: signed_out_path())
      |> halt()
    end
  end

  @doc """
  Redirects the connection to `signed_in_path/0` if an authenticated session exists.

  ## Usage
      # Router
      plug :redirect_if_authenticated
  """
  def redirect_if_authenticated(conn, _opts) do
    if conn.assigns[:identity] do
      conn
      |> redirect(to: signed_in_path())
      |> halt()
    else
      conn
    end
  end

  defp ensure_session_token(conn) do
    if token = get_session(conn, :session_token) do
      {token, conn}
    else
      conn = fetch_cookies(conn, signed: [session_cookie()])

      if token = conn.cookies[session_cookie()] do
        {token, ColorfulPandas.Web.Auth.put_token_in_session(conn, token)}
      else
        {nil, conn}
      end
    end
  end
end
