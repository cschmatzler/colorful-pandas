defmodule ColorfulPandas.Web do
  @moduledoc """
  Entrypoint for implementing the web interface to the service.

  Provides a `__using__/1` macro accepting one parameter specifying what the module is.
  """

  use Boundary, deps: [ColorfulPandas.Auth], exports: [Endpoint], top_level?: true

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def component do
    quote do
      use Phoenix.Component

      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      import ColorfulPandas.Web.Gettext
      import Phoenix.HTML

      alias Phoenix.LiveView.JS

      unquote(ColorfulPandas.Web.verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: ColorfulPandas.Web.Endpoint,
        router: ColorfulPandas.Web.Router,
        statics: ColorfulPandas.Web.static_paths()
    end
  end

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)
end
