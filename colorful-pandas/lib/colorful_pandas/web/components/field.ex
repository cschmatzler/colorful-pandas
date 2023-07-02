defmodule ColorfulPandas.Web.Components.Field do
  @moduledoc false
  use ColorfulPandas.Web, :component

  import ColorfulPandas.Web.Components.Icon
  import ColorfulPandas.Web.Components.Input

  attr :id, :string, required: true, doc: "Input element `id`"
  attr :type, :string, default: "text", values: ~w(text email), doc: "Input element `type`"
  attr :value, :string, default: nil, doc: "Input element `value`"
  attr :class, :string, default: nil, doc: "Extra input element classes"
  attr :label, :string, default: nil, doc: "Label"
  attr :label_class, :string, default: nil, doc: "Extra label element classes"
  attr :errors, :list, default: [], doc: "List of error messages"
  attr :rest, :global

  def field(assigns) do
    ~H"""
    <div class="w-full">
      <.label for={@id} class={@label_class} error={!Enum.empty?(@errors)}><%= @label %></.label>
      <.input id={@id} type={@type} value={@value} class="mt-1" {@rest} />
      <.errors errors={@errors} />
    </div>
    """
  end

  defp label(assigns) do
    ~H"""
    <div class="flex items-center justify-between">
      <label
        for={@for}
        class={[
          "block text-sm font-medium leading-6 text-gray-900",
          @class
        ]}
      >
        <%= render_slot(@inner_block) %>
      </label>
      <%= if @error do %>
        <.icon name="phosphor-warning" class="text-crimson-red" />
      <% end %>
    </div>
    """
  end

  defp errors(%{errors: [error]} = assigns) do
    assigns = assign(assigns, :error, error)

    ~H"""
    <p class="text-crimson-red mt-3 text-sm">
      <%= @error %>
    </p>
    """
  end

  defp errors(assigns) do
    ~H"""
    <ul class="mt-3 list-inside list-decimal space-y-1">
      <li :for={error <- @errors} class="text-crimson-red text-sm">
        <%= error %>
      </li>
    </ul>
    """
  end
end
