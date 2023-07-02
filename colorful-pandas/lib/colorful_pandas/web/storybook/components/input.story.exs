defmodule ColorfulPandas.Web.Storybook.Input do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias ColorfulPandas.Web.Components.Input

  def function, do: &Input.input/1

  def variations do
    [
      %Variation{
        id: :with_placeholder,
        attributes: %{placeholder: "Your name"}
      },
      %Variation{
        id: :with_value,
        attributes: %{value: "Mister Panda"}
      },
      %Variation{
        id: :with_type,
        attributes: %{type: "email", value: "astronaut@panda-den.com"}
      },
      %Variation{
        id: :submit,
        attributes: %{type: "submit", value: "Continue"}
      }
    ]
  end
end
