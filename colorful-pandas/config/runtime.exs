import Config

require Logger

if System.get_env("ENABLE_SERVER") do
  config :colorful_pandas, ColorfulPandas.Web.Endpoint, server: true
end

if System.get_env("ENABLE_TELEMETRY") do
  config :opentelemetry,
    resource: [
      service: [
        name: "colorful_pandas"
      ]
    ]

  config :opentelemetry_exporter,
    otlp_protocol: :http_protobuf,
    otlp_endpoint: System.fetch_env!("OTLP_ENDPOINT")
end

if config_env() in [:dev, :prod] do
  # --------
  # Database
  # --------
  db_url = System.fetch_env!("DB_URL")

  config :colorful_pandas, ColorfulPandas.Repo,
    url: db_url,
    ssl: true,
    ssl_opts: [
      cacertfile: CAStore.file_path(),
      verify: :verify_peer,
      server_name_indication:
        ~r/.*@(.*)\/.*/
        |> Regex.run(db_url, capture: :all_but_first)
        |> List.first()
        |> to_charlist(),
      customize_hostname_check: [
        match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
      ]
    ]

  # # Authentication
  # # --------------
  config :ueberauth, Ueberauth.Strategy.Github.OAuth,
    client_id: System.fetch_env!("GITHUB_CLIENT_ID"),
    client_secret: System.fetch_env!("GITHUB_CLIENT_SECRET")
end

# ---------
# Prod
# ---------
if config_env() == :prod do
  host = System.get_env("HOST")

  # ----------
  # Clustering
  # ----------

  config :libcluster,
    topologies: [
      render: [
        strategy: Cluster.Strategy.Kubernetes.DNS,
        config: [
          application_name: "colorful_pandas",
          service: System.fetch_env!("SERVICE_NAME")
        ]
      ]
    ]

  # --------
  # Database
  # --------

  config :colorful_pandas, ColorfulPandas.Repo, pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # ---
  # Web
  # ---
  config :colorful_pandas, ColorfulPandas.Web.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: System.fetch_env!("SECRET_KEY_BASE"),
    live_view: [
      signing_salt: System.fetch_env!("LIVEVIEW_SIGNING_SALT")
    ]

  # ----
  # Mail
  # ----
  config :colorful_pandas, ColorfulPandas.Mailer,
    adapter: Swoosh.Adapters.Postmark,
    # api_key: System.fetch_env!("POSTMARK_API_KEY")
    api_key: "nil"
end
