defmodule ColorfulPandas.Web.Components.Field do
  @moduledoc false
  use ColorfulPandas.Web, :component

  import ColorfulPandas.Web.Components.Helpers
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
    <div class="w-full space-y-2">
      <.label for={@id} class={@label_class}><%= @label %></.label>
      <.input id={@id} type={@type} value={@value} {@rest} />
      <.error :for={error <- @errors}><%= error %></.error>
    </div>
    """
  end

  defp label(assigns) do
    ~H"""
    <label
      for={@for}
      class={
        build_class([
          "block text-sm font-medium leading-6 text-gray-900",
          @class
        ])
      }
    >
      <%= render_slot(@inner_block) %>
    </label>
    """
  end

  defp error(assigns) do
    ~H"""
    <p class="text-sm text-crimson-red">
      <%= render_slot(@inner_block) %>
    </p>
    """
  end
end
