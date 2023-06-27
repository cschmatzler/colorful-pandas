defmodule ColorfulPandas.Web.Page do
  @moduledoc false
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def controller do
    quote do
      use Phoenix.Controller,
        namespace: ColorfulPandas.Web,
        formats: [:html, :json],
        layouts: [html: ColorfulPandas.Web.Layouts]

      import Plug.Conn

      unquote(ColorfulPandas.Web.verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {ColorfulPandas.Web.Layouts, :app},
        container: {:div, class: "h-full"}

      import Phoenix.HTML

      alias Phoenix.LiveView.JS

      unquote(ColorfulPandas.Web.verified_routes())
    end
  end
end
