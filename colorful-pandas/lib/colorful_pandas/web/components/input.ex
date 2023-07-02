defmodule ColorfulPandas.Web.Components.Input do
  @moduledoc false
  use ColorfulPandas.Web, :component

  import ColorfulPandas.Web.Components.Button
  import ColorfulPandas.Web.Components.Helpers

  attr :type, :string, default: "text", values: ~w(hidden email text), doc: "`type`"
  attr :value, :string, default: nil, doc: "`value`"
  attr :class, :string, default: nil, doc: "Extra classes"
  attr :rest, :global

  def input(%{type: "hidden"} = assigns) do
    ~H"""
    <input type="hidden" value={Phoenix.HTML.Form.normalize_value(@type, @value)} {@rest} />
    """
  end

  def input(%{type: "submit"} = assigns) do
    ~H"""
    <.button type="submit" label={@value} {@rest} />
    """
  end

  def input(assigns) do
    ~H"""
    <input
      type={@type}
      value={Phoenix.HTML.Form.normalize_value(@type, @value)}
      class={[
        "block w-full rounded-sm border-0 py-1.5 text-gray-900 ring-1 ring-inset ring-gray-300",
        "placeholder:text-gray-400",
        "focus:ring-2 focus:ring-inset focus:ring-chestnut",
        "sm:text-sm sm:leading-8",
        @class
      ]}
      {@rest}
    />
    """
  end
end
