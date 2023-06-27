defmodule ColorfulPandas.Web.Pages.Auth.Session do
  @moduledoc false
  use ColorfulPandas.Web.Page, :controller

  @doc """
  Ends an authenticated session.
  """
  def logout(conn, _params) do
    ColorfulPandas.Web.Auth.end_session(conn)
  end
end
