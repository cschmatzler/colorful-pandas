import Config

# -------------
# Observability
# -------------
config :logger, level: :info

config :opentelemetry,
  span_processor: :batch,
  exporter: :otlp,
  sampler: {:parent_based, %{root: {:trace_id_ratio_based, 0.1}}}

# ---
# Web
# ---
config :colorful_pandas, ColorfulPandas.Web.Endpoint, cache_static_manifest: "priv/static/cache_manifest.json"

# Mail
# ----
config :swoosh,
  api_client: Swoosh.ApiClient.Finch,
  finch_name: ColorfulPandas.Finch
