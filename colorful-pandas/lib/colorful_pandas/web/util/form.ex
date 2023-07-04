defmodule ColorfulPandas.Web.Util.Form do
  @moduledoc false
  import Ecto.Changeset

  def changeset(data, schema, action \\ nil) do
    types = schema |> Enum.map(fn {field, [type | _]} -> {field, type} end) |> Map.new()

    required = filter_field(schema, :required)

    {%{}, types}
    |> cast(data, Map.keys(types))
    |> validate_required(required)
    |> Map.put(:action, action)
  end

  defp filter_field(schema, field) do
    schema
    |> Enum.filter(fn {_, [_ | opts]} -> opts |> Map.new() |> Map.get(field, false) end)
    |> Enum.map(fn {k, _} -> k end)
  end
end
