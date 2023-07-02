defmodule ColorfulPandas.Web.Storybook.Button do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias ColorfulPandas.Web.Components.Button

  def function, do: &Button.button/1

  def variations do
    [
      %Variation{
        id: :submit,
        attributes: %{type: "submit", label: "Continue"}
      }
    ]
  end
end
