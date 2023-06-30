defmodule ColorfulPandas.Web.Storybook.Field do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias ColorfulPandas.Web.Components.Field

  def function, do: &Field.field/1

  def variations do
    [
      %Variation{
        id: :submit,
        attributes: %{type: "submit", label: "Submit"}
      },
      %Variation{
        id: :text,
        attributes: %{type: "text", id: "name", name: "name", value: "Mister Panda", label: "Name"}
      },
      %Variation{
        id: :email,
        attributes: %{
          type: "email",
          id: "email",
          name: "email",
          value: "astronaut@panda-den.com",
          label: "E-mail address"
        }
      },
      %Variation{
        id: :text_with_error,
        attributes: %{type: "text", id: "name", name: "name", value: "Not A Panda", label: "Name", errors: ["Name must include reference to a panda"]}
      },
    ]
  end
end
