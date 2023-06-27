defmodule ColorfulPandas.Web.Storybook.Input do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias ColorfulPandas.Web.Components.Input

  def function, do: &Input.input/1

  def variations do
    [
      %Variation{
        id: :submit,
        attributes: %{type: "submit", id: "username", name: "username", value: "User"}
      }
    ]
  end
end
