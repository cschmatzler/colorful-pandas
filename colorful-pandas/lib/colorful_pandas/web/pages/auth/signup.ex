defmodule ColorfulPandas.Web.Pages.Auth.Signup do
  @moduledoc false

  use ColorfulPandas.Web.Page, :live_view

  import ColorfulPandas.Web.Components.Button
  import ColorfulPandas.Web.Components.Input
  import ColorfulPandas.Web.Util.Form

  alias ColorfulPandas.Auth

  @details_schema [email: [:string, required: true], name: [:string, required: true]]
  @new_organization_schema [organization_name: [:string, required: true]]

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    with flow_id when not is_nil(flow_id) <- Map.get(session, "flow_id"),
         flow when not is_nil(flow) <-
           Auth.get_signup_flow(flow_id, preload: [invite: :organization]) do
      assigns = [flow: flow]

      {:ok, assign(socket, assigns)}
    else
      _ -> {:ok, push_redirect(socket, to: ~p"/")}
    end
  end

  @impl Phoenix.LiveView
  def handle_params(params, _uri, %{assigns: %{live_action: action}} = socket) do
    socket = handle_action_params(action, params, socket)
    {:noreply, socket}
  end

  defp handle_action_params(:details, _params, %{assigns: %{flow: flow}} = socket) do
    form = flow |> Map.from_struct() |> changeset(@details_schema, :update) |> to_form(as: "details")

    assigns = [form: form]
    assign(socket, assigns)
  end

  defp handle_action_params(:invite, _params, %{assigns: %{flow: %{invite: nil}}} = socket) do
    push_patch(socket, to: ~p"/auth/signup/new_organization")
  end

  defp handle_action_params(:invite, _params, %{assigns: %{flow: %{invite: invite}}} = socket) do
    assigns = [invite: invite]

    assign(socket, assigns)
  end

  defp handle_action_params(:new_organization, _params, %{assigns: %{flow: flow}} = socket) do
    form = flow |> Map.from_struct() |> changeset(@new_organization_schema) |> to_form(as: "organization")

    assigns = [form: form]
    assign(socket, assigns)
  end

  defp handle_action_params(:verify, _params, %{assigns: %{flow: flow}} = socket) do
    if is_nil(flow.invite) and is_nil(flow.organization_name) do
      push_patch(socket, to: ~p"/auth/signup/new_organization")
    else
      socket
    end
  end

  @impl Phoenix.LiveView
  def handle_event("submit-details", %{"details" => data}, %{assigns: %{flow: flow}} = socket) do
    # TODO: refactor and make smaller
    case changeset(data, @details_schema, :validate) do
      %Ecto.Changeset{valid?: true} = changeset ->
        {:ok, flow} = Auth.update_signup_flow(flow, changeset.changes)
        assign(socket, :flow, flow)

        if flow.invite do
          {:noreply, push_patch(socket, to: ~p"/auth/signup/invite")}
        else
          {:noreply, push_patch(socket, to: ~p"/auth/signup/new_organization")}
        end

      changeset ->
        form = to_form(changeset, as: "details")
        assigns = [form: form]

        {:noreply, assign(socket, assigns)}
    end
  end

  def handle_event("submit-organization", %{"organization" => data}, %{assigns: %{flow: flow}} = socket) do
    case changeset(data, @new_organization_schema, :validate) do
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

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <main class={["bg-white flex min-h-full flex-col justify-center py-12", "sm:px-6", "lg:px-8"]}>
      <div class="sm:mx-auto sm:w-full sm:max-w-sm">
        <h2 class="text-teal mt-10 text-center text-4xl font-bold leading-9 tracking-tight">
          Create your account
        </h2>
        <p class="mt-6 text-center text-gray-600">
          <span :if={@live_action == :details}>
            We have already pre-filled some information from your login provider - feel free to edit it as you see fit.
          </span>
          <span :if={@live_action == :invite}>
            You were invited to join <span class="font-bold"><%= @invite.organization.name %></span>.
          </span>
          <span :if={@live_action == :new_organization}>
            You are signing up without an invite to an existing organization - create a new one here.<br />
            Or, if you belong to an organization already using Colorful Pandas, ask your administrator to invite you.
          </span>
          <span :if={@live_action == :verify}>
            Please verify the following details before creating your account.
          </span>
        </p>
      </div>
      <div class={["mt-12", "sm:mx-auto sm:w-full sm:max-w-[480px]"]}>
        <div class={["bg-slate-100 px-6 py-8 smooth-shadow", "sm:rounded-lg sm:p-12"]}>
          <.details :if={@live_action == :details} form={@form} />
          <.invite :if={@live_action == :invite} invite={@invite} />
          <.new_organization :if={@live_action == :new_organization} form={@form} />
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

  defp invite(assigns) do
    ~H"""
    <p class="text-center">
      Invited by Christoph Schmatzler <.button label="Join" class="w-full mt-6" />
    </p>
    """
  end

  defp new_organization(assigns) do
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
          <%= @flow.organization_name %>
        </dd>
      </div>
    </dl>
    <div>
      <.button phx-click="create-account" label="Create account" class="w-full mt-6" />
    </div>
    """
  end
end
