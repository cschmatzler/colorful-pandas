defmodule ColorfulPandas.Web.ErrorHTML do
  @moduledoc false

  use ColorfulPandas.Web, :component

  def render(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
