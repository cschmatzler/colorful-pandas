defmodule ColorfulPandas.Web.Plugs.CSP do
  @moduledoc """
  Sets the Content-Security-Policy header.
  """

  @behaviour Plug

  import Phoenix.Controller, only: [put_secure_browser_headers: 2]

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _) do
    directives = [
      "default-src #{default_src_directive()}",
      "style-src #{style_src_directive()}",
      "font-src #{font_src_directive()}",
      "script-src #{script_src_directive()}",
      "img-src #{img_src_directive()}",
      "frame-src #{frame_src_directive()}",
      "connect-src #{connect_src_directive()}",
      "manifest-src #{manifest_src_directive()}"
    ]

    put_secure_browser_headers(conn, %{"content-security-policy" => Enum.join(directives, "; ")})
  end

  defp default_src_directive, do: "'none'"
  defp style_src_directive, do: "'self' 'unsafe-inline' fonts.bunny.net"
  defp font_src_directive, do: "'self' rsms.me fonts.bunny.net"
  defp script_src_directive, do: "'self' 'unsafe-inline' eu.posthog.com"
  defp img_src_directive, do: "'self' data:"
  defp frame_src_directive, do: "'self'"
  defp connect_src_directive, do: "'self' eu.posthog.com"
  defp manifest_src_directive, do: "'self'"
end
