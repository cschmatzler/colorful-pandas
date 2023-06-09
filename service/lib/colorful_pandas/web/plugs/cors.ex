defmodule ColorfulPandas.Web.Plugs.CORS do
  @moduledoc false

  use Corsica.Router,
      Application.compile_env(:colorful_pandas, Corsica)
end
