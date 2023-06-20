defmodule ColorfulPandas.Web.Pages.Auth.Signup do
  @moduledoc false

  use ColorfulPandas.Web.Page, :live_view

  import Ecto.Changeset

  alias ColorfulPandas.Auth
  alias ColorfulPandas.Auth.SignupFlow

  @form_schema [
    email: [:string, required: true],
    name: [:string, required: true]
  ]

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    with flow_id when not is_nil(flow_id) <- Map.get(params, "flow"),
         %SignupFlow{} = flow <- Auth.get_signup_flow(flow_id) do
      form = @form_schema |> changeset(Map.from_struct(flow), :update) |> to_form(as: "signup")
      socket = assign(socket, flow: flow, form: form)

      {:ok, socket}
    else
      nil ->
        {:ok, redirect(socket, to: ~p"/")}
    end
  end

  defp changeset(schema, data, action) do
    types = schema |> Enum.map(fn {field, [type | _]} -> {field, type} end) |> Map.new()

    required =
      schema
      |> Enum.filter(fn {_, [_ | opts]} -> opts |> Map.new() |> Map.get(:required, false) end)
      |> Enum.map(fn {k, _} -> k end)

    {%{}, types}
    |> cast(data, Map.keys(types))
    |> validate_required(required)
    |> Map.put(:action, :validate)
  end

  @impl Phoenix.LiveView
  def handle_event(_event, params, socket) do
    form = @form_schema |> changeset(params, :update) |> to_form(as: "signup")
    socket = assign(socket, :form, form)
    IO.inspect(form.errors)

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <.form class="flex flex-col" for={@form} phx-change="update-flow">
      <input type="email" name="email" value={@form[:email].value} />
      <%= Keyword.get(@form.errors, :email) %>
      <input type="text" name="name" value={@form[:name].value} />
    </.form>
    """
  end
end
