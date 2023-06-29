defmodule ColorfulPandas.Web.Pages.Landing do
  @moduledoc false
  use ColorfulPandas.Web.Page, :live_view

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="h-full bg-vellum">
      <.main />
    </div>
    """
  end

  defp main(assigns) do
    ~H"""
    <div class="pt-20">
      <div class="py-48 sm:py-64 lg:pb-40">
        <div class="mx-auto max-w-2xl text-center">
          <h1 class="text-4xl font-bold tracking-tight text-moss sm:text-6xl">
            Stuff.
          </h1>
          <p class="mt-6 text-lg leading-8 text-moss/80">
            ... and more. Some day. Maybe.
          </p>
        </div>
      </div>
    </div>
    """
  end
end
