defmodule ColorfulPandas.Web.Endpoint do
  @moduledoc false

  use Phoenix.Endpoint, otp_app: :colorful_pandas

  @session_options [
    store: :cookie,
    key: "_session",
    signing_salt: "S8DoleIF",
    same_site: "Lax"
  ]

  socket("/live", Phoenix.LiveView.Socket,
    websocket: [
      connect_info: [
        session: @session_options
      ]
    ]
  )

  plug Plug.Static,
    at: "/",
    from: :colorful_pandas,
    gzip: true,
    only: ColorfulPandas.Web.static_paths()

  if code_reloading? do
    socket("/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket)
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug RemoteIp, headers: ["cf-connecting-ip", "x-forwarded-for"]
  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Jason

  plug Plug.MethodOverride
  plug Plug.Head
  plug ColorfulPandas.Web.Plugs.CSP
  plug ColorfulPandas.Web.Plugs.CORS
  plug Plug.Session, @session_options
  plug ColorfulPandas.Web.Router
end
