defmodule ColorfulPandas.Web.Pages.Admin.Organizations do
  @moduledoc false
  use Phoenix.LiveView

  import ColorfulPandas.Web.Components.Sidebar
  alias ColorfulPandas.Auth

  @impl Phoenix.LiveView
  def handle_params(_params, _uri, socket) do
    organizations = Auth.list_organizations()

    {:noreply, assign(socket, organizations: organizations)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.sidebar user={@user}>
      <:navigation>
        <.sidebar_item label="Test" />
      </:navigation>
    </.sidebar>
    <ul>
      <li :for={organization <- @organizations}><%= organization.name %></li>
    </ul>
    """
  end
end
