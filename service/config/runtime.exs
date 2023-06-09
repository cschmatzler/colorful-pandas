import Config

if System.get_env("ENABLE_SERVER") do
  config :colorful_pandas, ColorfulPandas.Web.Endpoint, server: true
end

if config_env() in [:dev, :prod] do
  db_url = System.fetch_env!("DB_URL")

  config :colorful_pandas, ColorfulPandas.Repo,
    url: db_url,
    ssl: true,
    ssl_opts: [
      verify: :verify_none,
      server_name_indication:
        Regex.run(~r/.*@(.*)\/.*/, db_url, capture: :all_but_first)
        |> List.first()
        |> to_charlist(),
    ]
end

# ---------
# Prod
# ---------
if config_env() == :prod do
  host = System.get_env("HOST")

  # -------------
  # Observability
  # -------------
  config :opentelemetry,
    resource: [
      service: [
        name: "colorful_pandas",
        namespace: System.fetch_env!("NAMESPACE")
      ],
      host: [
        name: host
      ]
    ]

  config :opentelemetry_exporter,
    otlp_protocol: :http_protobuf,
    otlp_endpoint: System.fetch_env!("OTLP_ENDPOINT")

  # ----------
  # Clustering
  # ----------
  # dns_name = System.get_env("RENDER_DISCOVERY_SERVICE")
  # app_name = System.get_env("RENDER_SERVICE_NAME")
  #
  # config :libcluster,
  #   topologies: [
  #     render: [
  #       strategy: Cluster.Strategy.Kubernetes.DNS,
  #       config: [
  #         service: dns_name,
  #         application_name: app_name
  #       ]
  #     ]
  #   ]

  # --------
  # Database
  # --------

  config :colorful_pandas, ColorfulPandas.Repo,
    url: System.fetch_env!("DB_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

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
    api_key: System.fetch_env!("POSTMARK_API_KEY")
end
