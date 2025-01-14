defmodule ColorfulPandas.Web.Router do
  @moduledoc false

  use Phoenix.Router, helpers: false

  import ColorfulPandas.Web.Plugs.Auth
  import Phoenix.Controller
  import Phoenix.LiveView.Router
  import PhoenixStorybook.Router
  import Plug.Conn

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ColorfulPandas.Web.Layouts, :root}
    plug :protect_from_forgery
    plug :fetch_identity
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", ColorfulPandas.Web.Pages do
    pipe_through :browser

    live_session :landing,
      on_mount: [
        {ColorfulPandas.Web.Auth, :mount_user}
      ] do
      live "/", Landing, :index, as: :landing
    end
  end

  scope "/auth", ColorfulPandas.Web.Pages.Auth do
    pipe_through [:browser, :redirect_if_authenticated]

    get "/signup/auth/invite", Invite, :show
    live "/signup/details", Signup, :details, as: :signup
    live "/signup/organization", Signup, :organization, as: :signup
    live "/signup/verify", Signup, :verify, as: :signup
    delete "/session", Session, :logout
  end

  scope "/auth/oauth", ColorfulPandas.Web.Pages.Auth do
    pipe_through [:browser, :redirect_if_authenticated]

    get "/:provider", OAuth, :request
    get "/:provider/callback", OAuth, :callback
  end

  scope "/admin", ColorfulPandas.Web.Pages.Admin do
    pipe_through :browser

    live_session :admin,
      on_mount: [
        {ColorfulPandas.Web.Auth, :mount_user},
        {ColorfulPandas.Web.Auth, :require_session}
      ] do
      live "/organizations", Organizations, as: :organizations
    end
  end

  scope "/admin" do
    live_storybook("/storybook", backend_module: ColorfulPandas.Web.Storybook)
  end

  if Application.compile_env(:colorful_pandas, :dev_routes) do
    scope "/dev" do
      pipe_through :browser

      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
