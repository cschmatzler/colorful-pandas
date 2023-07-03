defmodule ColorfulPandas.Web.Storybook.Input do
  @moduledoc false
  use PhoenixStorybook.Story, :component

  alias ColorfulPandas.Web.Components.Input

  def function, do: &Input.input/1

  def variations do
    [
      %Variation{
        id: :with_form_field,
        template: """
        <.form :let={f} for={to_form(%{"name" => "Panda"})} class="w-full">
          <.lsb-variation field={f["name"]} />
        </.form>
        """,
        attributes: %{label: "Name"}
      },
      %Variation{
        id: :with_form_field_and_error,
        template: """
        <.form :let={f} for={to_form(%{"name" => "Panda"}, errors: %{"name" => "Must be at least 354 characters."})} class="w-full">
          <.lsb-variation field={f["name"]} />
        </.form>
        """,
        attributes: %{label: "Name"}
      },
      %Variation{
        id: :with_label,
        attributes: %{id: "name", name: "name", label: "Name", value: ""}
      },
      %Variation{
        id: :with_placeholder,
        attributes: %{id: "name", name: "name", placeholder: "Your name", value: ""}
      },
      %Variation{
        id: :with_value,
        attributes: %{id: "name", name: "name", value: "Mister Panda"}
      },
      %Variation{
        id: :with_type,
        attributes: %{
          type: "email",
          id: "email",
          name: "email",
          value: "astronaut@panda-den.com"
        }
      },
      %Variation{
        id: :with_error,
        attributes: %{
          id: "name",
          name: "name",
          value: "Not A Panda",
          errors: ["Name must include reference to a panda"]
        }
      },
      %Variation{
        id: :with_multiple_errors,
        attributes: %{
          id: "name",
          name: "name",
          value: "Not A Panda",
          errors: ["Name must include reference to a panda", "Name is already in use"]
        }
      }
    ]
  end
end
