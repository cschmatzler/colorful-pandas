import Config

# -------------
# Observability
# -------------
config :logger, :console, format: "[$level] $message\n", level: :debug
config :opentelemetry, traces_exporter: :none

# --------
# Database
# --------
config :colorful_pandas, ColorfulPandas.Repo,
  stacktrace: true,
  # Increase timeout to give database time to spin up
  connect_timeout: 10_000,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# ---
# Web
# ---
config :colorful_pandas, dev_routes: true

config :colorful_pandas, ColorfulPandas.Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "QO5FvhA4dGbDCsISsEv3rzECQIBYjPtnThS7ZU08B27DUcDzgvukVmFfxz/qZ19N",
  live_view: [signing_salt: "17k0tPiq"],
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ],
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/colorful_pandas/web/*/*.*ex$"
    ]
  ]

# ----
# Mail
# ----
config :swoosh, :api_client, false
config :colorful_pandas, ColorfulPandas.Mailer, adapter: Swoosh.Adapters.Local
