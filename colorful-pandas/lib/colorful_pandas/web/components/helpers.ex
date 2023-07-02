defmodule ColorfulPandas.Web.Components.Helpers do
  @moduledoc false

  def build_class(list, joiner \\ " ") do
    list |> Enum.reject(&(&1 in [nil, ""])) |> Enum.map_join(joiner, &String.trim(&1))
  end
end
