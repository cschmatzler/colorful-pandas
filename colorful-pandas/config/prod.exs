import Config

# -------------
# Observability
# -------------
config :logger, :default_handler, level: :error
config :logger, :default_formatter, format: "$time $message $metadata"

config :opentelemetry,
  span_processor: :batch,
  exporter: :otlp,
  sampler: {:parent_based, %{root: {:trace_id_ratio_based, 0.1}}}

# User monitoring
# ---------------
config :colorful_pandas, :posthog, enabled?: true

# --------
# Database
# --------
db_url = System.get_env("DB_URL")
config :colorful_pandas, ColorfulPandas.Repo,
  url: db_url

# ---
# Web
# ---
config :colorful_pandas, ColorfulPandas.Web.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Mail
# ----
config :swoosh,
  local: false,
  api_client: Swoosh.ApiClient.Finch,
  finch_name: ColorfulPandas.Finch
