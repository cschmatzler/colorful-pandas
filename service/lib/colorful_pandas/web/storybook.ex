defmodule ColorfulPandas.Web.Storybook do
  @moduledoc false
  use PhoenixStorybook,
    otp_app: :colorful_pandas,
    title: "Colorful Pandas",
    content_path: Path.expand("./storybook", __DIR__),
    css_path: "/assets/css/app.css",
    js_path: "/assets/js/app.js",
  compilation_mode: :lazy
end
