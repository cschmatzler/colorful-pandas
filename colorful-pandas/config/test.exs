import Config

# -------
# Logging
# -------
config :logger, level: :warning

# --------
# Database
# --------
config :colorful_pandas, ColorfulPandas.Repo,
  username: "postgres",
  password: "postgres",
  hostname: System.get_env("DB_HOST") || "localhost",
  database: "colorful_pandas_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# ---
# Web
# ---
config :colorful_pandas, ColorfulPandas.Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "psMlmgXsUK7hJMaoJWZXzSHrbTLdJeBS3Cn+LEoMueyEt78DJtPA5G9dkvoxpBku",
  live_view: [signing_salt: "17k0tPiq"],
  server: false

# ----
# Jobs
# ----
config :colorful_pandas, Oban, testing: :inline

# ----
# Mail
# ----
config :colorful_pandas, ColorfulPandas.Mailer, adapter: Swoosh.Adapters.Test
config :swoosh, :api_client, false
