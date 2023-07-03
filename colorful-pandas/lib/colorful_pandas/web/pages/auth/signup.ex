defmodule ColorfulPandas.Web.Pages.Auth.Signup do
  @moduledoc false

  use ColorfulPandas.Web.Page, :live_view

  import ColorfulPandas.Web.Components.Input
  import Ecto.Changeset

  alias ColorfulPandas.Auth
  alias ColorfulPandas.Auth.SignupFlow

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    with flow_id when not is_nil(flow_id) <- Map.get(params, "flow"),
         %SignupFlow{} = flow <- Auth.get_signup_flow(flow_id) do
      form = schema() |> changeset(Map.from_struct(flow), :update) |> to_form(as: "signup")
      socket = assign(socket, flow: flow, form: form)

      {:ok, socket}
    else
      nil ->
        {:ok, redirect(socket, to: ~p"/")}
    end
  end

  defp schema do
    [email: [:string, required: true], name: [:string, required: true]]
  end

  # TODO: Make this reusable
  defp changeset(schema, data, action \\ :validate) do
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
  def handle_event(_event, params, socket) do
    form = schema() |> changeset(params) |> to_form(as: "signup")
    socket = assign(socket, :form, form)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.form for={@form} phx-change="update-flow" class="flex flex-col">
      <.input field={@form[:email]} label="Email address" />
      <.input field={@form[:name]} label="Name" />
    </.form>
    """
  end
end
