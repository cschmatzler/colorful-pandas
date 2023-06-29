defmodule ColorfulPandas.Application do
  @moduledoc """
  Main entrypoint for the service.
  """

  use Boundary, deps: [ColorfulPandas.Repo, ColorfulPandas.Web], top_level?: true
  use Application

  @impl Application
  def start(_type, _args) do
    # OpentelemetryEcto.setup([:colorful_pandas, :repo])
    # OpentelemetryOban.setup(trace: [:jobs])
    # OpentelemetryFinch.setup()
    # OpentelemetryPhoenix.setup()
    # OpentelemetryLiveView.setup()

    children = [
      {Cluster.Supervisor,
       [
         Application.fetch_env!(:libcluster, :topologies),
         [name: ColorfulPandas.ClusterSupervisor]
       ]},
      {Phoenix.PubSub, name: ColorfulPandas.PubSub},
      {Finch, name: ColorfulPandas.Finch},
      ColorfulPandas.Repo,
      {Oban, Application.fetch_env!(:colorful_pandas, Oban)},
      ColorfulPandas.Web.Endpoint
    ]

    opts = [strategy: :one_for_one, name: ColorfulPandas.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl Application
  def config_change(changed, _new, removed) do
    ColorfulPandas.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
