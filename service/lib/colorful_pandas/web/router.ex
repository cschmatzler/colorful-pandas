defmodule ColorfulPandas.Web.Router do
  @moduledoc false

  use Phoenix.Router, helpers: false

  import Phoenix.Controller
  import Phoenix.LiveView.Router
  import Plug.Conn

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {ColorfulPandas.Web.Layouts, :root})
    plug(:protect_from_forgery)
  end

  scope "/", ColorfulPandas.Web.Pages do
    pipe_through(:browser)

    live_session :landing do
      live("/", Landing, :index, as: :landing)
    end
  end

  if Application.compile_env(:colorful_pandas, :dev_routes) do
    scope "/dev" do
      pipe_through(:browser)

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
