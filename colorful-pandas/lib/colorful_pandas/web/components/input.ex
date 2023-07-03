defmodule ColorfulPandas.Web.Components.Input do
  @moduledoc false
  use ColorfulPandas.Web, :component

  import ColorfulPandas.Web.Components.Icon

  attr :label, :string, default: nil, doc: "Label"
  attr :type, :string, default: "text", values: ~w(hidden email text), doc: "`type`"
  attr :field, :any, doc: "Form field"
  attr :name, :string, doc: "`name`"
  attr :id, :string, doc: "`id`"
  attr :value, :string, default: nil, doc: "`value`"
  attr :class, :string, default: nil, doc: "Extra classes"
  attr :errors, :list, default: [], doc: "List of error messages"
  attr :rest, :global

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, IO.inspect(field.errors))
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> input()
  end

  def input(%{type: "hidden"} = assigns) do
    ~H"""
    <input type="hidden" value={Phoenix.HTML.Form.normalize_value(@type, @value)} {@rest} />
    """
  end

  def input(assigns) do
    ~H"""
    <div class="w-full" phx-feedback-for={@name}>
      <div class="flex items-center justify-between">
        <label for={@id} class="block text-sm font-medium leading-6 text-gray-900">
          <%= @label %>
        </label>
        <%= if length(@errors) > 0 do %>
          <.icon name="phosphor-warning" class="text-crimson-red" />
        <% end %>
      </div>
      <input
        type={@type}
        name={@name}
        id={@id}
        value={Phoenix.HTML.Form.normalize_value(@type, @value)}
        class={[
          "block w-full rounded-sm border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300",
          "placeholder:text-gray-400",
          "focus:ring-chestnut focus:ring-2 focus:ring-inset",
          "sm:text-sm sm:leading-8",
          @class
        ]}
        {@rest}
      />
      <ul
        :if={length(@errors) > 0}
        class={[
          "mt-3 list-inside space-y-1",
          if(length(@errors) > 1, do: "list-decimal", else: "")
        ]}
      >
        <li :for={error <- @errors} class="text-crimson-red text-sm">
          <%= error %>
        </li>
      </ul>
    </div>
    """
  end
end
