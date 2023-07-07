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
            Pandas.
          </h1>

          <.link href={~p"/auth/oauth/github"}>Sign up</.link>

          <p class="mt-6 text-sm leading-8 text-moss/60">
            Version <%= to_string(Application.spec(:colorful_pandas, :vsn)) %>
          </p>
        </div>
      </div>
    </div>
    """
  end
end
