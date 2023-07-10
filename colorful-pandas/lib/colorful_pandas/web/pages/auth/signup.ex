defmodule ColorfulPandas.Web.Pages.Auth.Signup do
  @moduledoc false

  use ColorfulPandas.Web.Page, :live_view

  import ColorfulPandas.Web.Components.Button
  import ColorfulPandas.Web.Components.Input
  import ColorfulPandas.Web.Util.Form

  alias ColorfulPandas.Auth
  alias ColorfulPandas.Auth.SignupFlow
  alias ColorfulPandas.Web.Auth, as: WebAuth

  @details_schema [email: [:string, required: true], name: [:string, required: true]]
  @organization_schema [organization_name: [:string, required: true]]

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    with flow_id when not is_nil(flow_id) <- Map.get(session, "flow_id"),
         %SignupFlow{} = flow <- Auth.get_signup_flow(flow_id, preload: [invite: :organization]) do
      {:ok, assign(socket, flow: flow)}
    else
      _ -> {:ok, push_redirect(socket, to: WebAuth.signed_out_path())}
    end
  end

  @impl Phoenix.LiveView
  def handle_params(params, _uri, %{assigns: %{live_action: action}} = socket) do
    socket = handle_action_params(action, params, socket)
    {:noreply, socket}
  end

  defp handle_action_params(:details, _params, socket) do
    %{assigns: %{flow: flow}} = socket
    form = flow |> Map.from_struct() |> changeset(@details_schema, :update) |> to_form(as: "details")

    assign(socket, form: form)
  end

  defp handle_action_params(:organization, _params, socket) do
    %{assigns: %{flow: flow}} = socket
    form = flow |> Map.from_struct() |> changeset(@organization_schema) |> to_form(as: "organization")

    assign(socket, form: form)
  end

  defp handle_action_params(:verify, _params, %{assigns: %{flow: flow}} = socket) do
    if is_nil(flow.invite) and is_nil(flow.organization_name) do
      push_patch(socket, to: ~p"/auth/signup/organization")
    else
      socket
    end
  end

  @impl Phoenix.LiveView
  def handle_event("submit-details", %{"details" => data}, %{assigns: %{flow: flow}} = socket) do
    data |> changeset(@details_schema, :validate) |> handle_details_changeset(flow, socket)
  end

  def handle_event("submit-organization", %{"organization" => data}, %{assigns: %{flow: flow}} = socket) do
    case changeset(data, @organization_schema, :validate) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, flow} = Auth.update_signup_flow(flow, changeset.changes)
        socket = socket |> assign(flow: flow) |> push_patch(to: ~p"/auth/signup/verify")

        {:noreply, socket}

      changeset ->
        form = to_form(changeset, as: "organization")
        assigns = [form: form]

        {:noreply, assign(socket, assigns)}
    end
  end

  def handle_event("create-account", _params, %{assigns: %{flow: flow}} = socket) do
    {:ok, _} = Auth.create_identity_from_flow(flow)

    # NOTE: We are just redirecting back to the OAuth provider from here - might be room for efficiency improvements at some point.
    {:noreply, redirect(socket, to: ~p"/auth/oauth/#{flow.provider}")}
  end

  defp handle_details_changeset(%Ecto.Changeset{valid?: true} = changeset, flow, socket) do
    {:ok, updated_flow} = Auth.update_signup_flow(flow, changeset.changes)
    socket = assign(socket, :flow, updated_flow)

    path = if(updated_flow.invite, do: ~p"/auth/signup/verify", else: ~p"/auth/signup/organization")

    {:noreply, push_patch(socket, to: path)}
  end

  defp handle_details_changeset(changeset, _flow, socket) do
    form = to_form(changeset, as: "details")
    {:noreply, assign(socket, form: form)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <main class={["bg-light-blue flex min-h-full flex-col justify-center py-12", "sm:px-6", "lg:px-8"]}>
      <div class="sm:mx-auto sm:w-full sm:max-w-lg">
        <h2 class="text-teal text-center text-4xl font-bold leading-9 tracking-tight">
          Create your account
        </h2>
        <p class="mt-6 px-6 sm:px-0 text-center text-gray-600">
          <span :if={@live_action == :details}>
            We have already pre-filled some information from your login provider.
          </span>
          <span :if={@live_action == :organization}>
            You are signing up without an invite to an existing organization.<br /> Create a new one or ask your administrator to invite you.
          </span>
          <span :if={@live_action == :verify}>
            Please verify the following details before creating your account.
          </span>
        </p>
      </div>
      <div class={["mt-12", "sm:mx-auto sm:w-full sm:max-w-[480px]"]}>
        <div class="px-6 sm:px-0">
          <.details :if={@live_action == :details} form={@form} />
          <.organization :if={@live_action == :organization} form={@form} />
          <.verify :if={@live_action == :verify} flow={@flow} />
        </div>
      </div>
    </main>
    """
  end

  defp details(assigns) do
    ~H"""
    <.form for={@form} phx-submit="submit-details" class="space-y-4">
      <div>
        <.input field={@form[:email]} label="Email address" placeholder="astronaut@colorful-pandas.com" />
      </div>
      <div>
        <.input field={@form[:name]} label="Name" placeholder="Astronaut Panda" />
      </div>
      <div>
        <.button type="submit" label="Continue" class="w-full mt-6" />
      </div>
    </.form>
    """
  end

  defp organization(assigns) do
    ~H"""
    <.form for={@form} phx-submit="submit-organization" class="space-y-4">
      <div>
        <.input field={@form[:organization_name]} label="Name" placeholder="Panda Den" />
      </div>
      <div>
        <.button type="submit" label="Continue" class="w-full mt-6" />
      </div>
    </.form>
    """
  end

  defp verify(assigns) do
    ~H"""
    <dl>
      <div class="px-4 py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
        <dt class="text-sm font-medium leading-6 text-gray-900">Email address</dt>
        <dd class="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0"><%= @flow.email %></dd>
      </div>
      <div class="px-4 py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
        <dt class="text-sm font-medium leading-6 text-gray-900">Name</dt>
        <dd class="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0"><%= @flow.name %></dd>
      </div>
      <div class="px-4 py-2 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-0">
        <dt class="text-sm font-medium leading-6 text-gray-900">Organization</dt>
        <dd class="mt-1 text-sm leading-6 text-gray-700 sm:col-span-2 sm:mt-0">
          <%= @flow.invite.organization.name || @flow.organization_name %>
        </dd>
      </div>
    </dl>
    <div>
      <.button phx-click="create-account" label="Create account" class="w-full mt-6" />
    </div>
    """
  end
end
