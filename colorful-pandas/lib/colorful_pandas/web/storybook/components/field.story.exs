defmodule ColorfulPandas.Web.Storybook.Field do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias ColorfulPandas.Web.Components.Field

  def function, do: &Field.field/1

  def variations do
    [
      %Variation{
        id: :with_label,
        attributes: %{label: "Name"}
      },
      %Variation{
        id: :with_error,
        attributes: %{
          label: "Name",
          value: "Not A Panda",
          errors: ["Name must include reference to a panda"]
        }
      }
    ]
  end
end
