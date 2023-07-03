defmodule ColorfulPandas.Web.Components.Button do
  @moduledoc false

  use ColorfulPandas.Web, :component

  attr :type, :string, default: "button", values: ~w(submit button), doc: "`type`"
  attr :variant, :string, default: "primary", values: ~w(primary secondary)
  attr :label, :string, default: nil, doc: "Label"
  attr :class, :string, default: nil, doc: "Extra classes"
  attr :rest, :global

  def button(assigns) do
    ~H"""
    <button
      type={@type}
      class={[
        "rounded-sm px-6 py-2.5 text-sm font-semibold text-white shadow-sm",
        "focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2",
        variant_class(@variant),
        @class
      ]}
      {@rest}
    >
      <%= @label %>
    </button>
    """
  end

  defp variant_class("primary"), do: ["bg-teal", "hover:bg-teal/80", "focus-visible:outline-teal"]

  defp variant_class(_), do: ""
end
