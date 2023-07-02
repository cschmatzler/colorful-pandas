defmodule ColorfulPandas.Web.Storybook do
  @moduledoc false
  use PhoenixStorybook,
    otp_app: :colorful_pandas,
    title: "Colorful Pandas",
    content_path: Path.expand("storybook", __DIR__),
    css_path: "/assets/app.css",
    js_path: "/assets/app.js"
end
