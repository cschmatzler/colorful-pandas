defmodule ColorfulPandas.MixProject do
  use Mix.Project

  def project do
    [
      app: :colorful_pandas,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        colorful_pandas: [
          applications: [
            colorful_pandas: :permanent,
            opentelemetry_exporter: :permanent,
            opentelemetry: :temporary
          ]
        ]
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      mod: {ColorfulPandas.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp deps do
    [
      {:bandit, "~> 0.7"},
      {:boundary, "~> 0.9", runtime: false},
      {:castore, "~> 1.0"},
      {:carbonite, "~> 0.9"},
      {:corsica, "~> 2.0"},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ecto_sql, "~> 3.9"},
      {:esbuild, "~> 0.7"},
      {:ex_doc, "~> 0.30", runtime: false},
      {:excellent_migrations, "~> 0.1", only: [:dev, :test], runtime: false},
      {:finch, "~> 0.16"},
      {:gettext, "~> 0.22"},
      {:hammox, "~> 0.7", only: :test},
      {:jason, "~> 1.4"},
      {:knigge, "~> 1.4"},
      {:libcluster, "~> 3.3"},
      {:oban, "~> 2.14"},
      {:opentelemetry_exporter, "~> 1.2"},
      {:opentelemetry, "~> 1.3"},
      {:opentelemetry_api, "~> 1.0"},
      {:opentelemetry_ecto, "~> 1.1"},
      {:opentelemetry_finch, "~> 0.2"},
      {:opentelemetry_liveview, "~> 1.0-rc.4"},
      {:opentelemetry_oban, "~> 1.0"},
      {:opentelemetry_phoenix, "~> 1.1"},
      {:phoenix, "~> 1.7"},
      {:phoenix_ecto, "~> 4.4"},
      {:phoenix_html, "~> 3.3"},
      {:phoenix_live_reload, "~> 1.4", only: :dev},
      {:phoenix_live_view, "~> 0.19"},
      {:phoenix_storybook, "~> 0.5"},
      {:postgrex, "~> 0.17"},
      {:remote_ip, "~> 1.1"},
      {:sobelow, "~> 0.12", only: [:dev, :test], runtime: false},
      {:styler, "~> 0.8", only: [:dev, :test], runtime: false},
      {:swoosh, "~> 1.9"},
      {:tailwind, "~> 0.2"},
      {:tesla, "~> 1.7"},
      {:ueberauth, "~> 0.10"},
      {:ueberauth_github, "~> 0.8"}
    ]
  end
end
