defmodule ColorfulPandas.Web.Components.Icon do
  @moduledoc false

  use ColorfulPandas.Web, :component

  attr :name, :string, required: true
  attr :class, :string, default: ""

  def icon(%{name: "phosphor-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end
end
