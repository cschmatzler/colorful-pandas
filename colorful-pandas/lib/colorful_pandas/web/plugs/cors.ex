defmodule ColorfulPandas.Web.Plugs.CORS do
  # TODO: Add doc
  @moduledoc false

  use Corsica.Router,
      Application.compile_env(:colorful_pandas, Corsica)
end
