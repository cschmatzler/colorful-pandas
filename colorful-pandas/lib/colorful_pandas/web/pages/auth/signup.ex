defmodule ColorfulPandas.Web.Pages.Auth.Signup do
  @moduledoc false

  use ColorfulPandas.Web.Page, :live_view

  import ColorfulPandas.Web.Components.Button
  import ColorfulPandas.Web.Components.Input
  import Ecto.Changeset

  alias ColorfulPandas.Auth

  @impl Phoenix.LiveView
  def handle_params(params, _uri, socket) do
    with flow_id when not is_nil(flow_id) <- Map.get(params, "flow_id"),
         flow when not is_nil(flow) <- Auth.get_signup_flow(flow_id) do
      form = flow |> Map.from_struct() |> changeset(:update) |> to_form(as: "details")
      socket = assign(socket, flow: flow, invite: flow.invite, form: form)
      {:noreply, socket}
    else
      nil ->
        {:ok, redirect(socket, to: ~p"/")}
    end
  end

  # TODO: Make this reusable
  defp changeset(data, action) do
    schema = [email: [:string, required: true], name: [:string, required: true]]
    types = schema |> Enum.map(fn {field, [type | _]} -> {field, type} end) |> Map.new()

    required =
      schema
      |> Enum.filter(fn {_, [_ | opts]} -> opts |> Map.new() |> Map.get(:required, false) end)
      |> Enum.map(fn {k, _} -> k end)

    {%{}, types}
    |> cast(data, Map.keys(types))
    |> validate_required(required)
    |> Map.put(:action, action)
  end

  @impl Phoenix.LiveView
  def handle_event("submit-details", %{"details" => %{"email" => email, "name" => name}}, socket) do
    Auth.update_signup_flow(socket.assigns.flow, email, name)
    {:noreply, push_patch(socket, to: ~p"/auth/signup/#{socket.assigns.flow.id}/invite")}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <main class={["bg-rose flex min-h-full flex-col justify-center py-12", "sm:px-6", "lg:px-8"]}>
      <div class="sm:mx-auto sm:w-full sm:max-w-sm">
        <h2 class="text-teal mt-10 text-center text-4xl font-bold leading-9 tracking-tight">
          Create your account
        </h2>
        <p class="mt-4 text-center text-gray-600">
          <span :if={@live_action == :details}>
            We have already pre-filled some information from your login provider - feel free to edit it as you see fit.
          </span>
          <span :if={@live_action == :invite}>
            You were invited to join <span class="font-bold">Phrase</span>.
          </span>
        </p>
      </div>
      <div class={["mt-12", "sm:mx-auto sm:w-full sm:max-w-[480px]"]}>
        <div class={["bg-slate-100 px-6 py-8 smooth-shadow", "sm:rounded-lg sm:p-12"]}>
          <.details :if={@live_action == :details} form={@form} />
          <.invite :if={@live_action == :invite} invite={@invite} />
        </div>
      </div>
    </main>
    """
  end

  defp details(assigns) do
    ~H"""
    <.form for={@form} phx-submit="submit-details" class="space-y-4">
      <div>
        <.input
          field={@form[:email]}
          label="Email address"
          placeholder="astronaut@colorful-pandas.com"
        />
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
end
