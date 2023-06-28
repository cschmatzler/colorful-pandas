import Config

# ----------
# Clustering
# ----------
config :libcluster, topologies: []

# --------
# Database
# --------
config :colorful_pandas,
  ecto_repos: [ColorfulPandas.Repo]

# ----
# Jobs
# ----
config :colorful_pandas, Oban,
  repo: ColorfulPandas.Repo,
  prefix: "jobs",
  plugins: [Oban.Plugins.Pruner, {Oban.Plugins.Reindexer, schedule: "@weekly"}],
  queues: [default: 10, mail: 10]

# Authentication
# --------------
config :ueberauth, Ueberauth,
  base_path: "/auth/oauth",
  providers: [
    github: {Ueberauth.Strategy.Github, []}
  ]

# ---
# Web
# ---
config :colorful_pandas, Corsica, origins: "*", allow_headers: :all

config :colorful_pandas, ColorfulPandas.Web.Endpoint,
  adapter: Bandit.PhoenixAdapter,
  pubsub_server: ColorfulPandas.PubSub,
  render_errors: [
    formats: [html: ColorfulPandas.Web.ErrorHTML, json: ColorfulPandas.Web.ErrorJSON],
    layout: false
  ]

# ------
# Web Assets
# ------
config :esbuild,
  version: "0.18.4",
  default: [
    args: ~w(js/app.js --bundle --target=es2020 --outdir=../priv/static/assets --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.3.2",
  default: [
    args: ~w(
      --config=tailwind.config.cjs
      --input=css/app.css
      --output=../priv/static/assets/css/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :colorful_pandas, :posthog,
  enabled?: false

import_config "#{config_env()}.exs"
