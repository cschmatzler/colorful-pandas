defmodule ColorfulPandas.Web.Components.Sidebar do
  @moduledoc false
  use Phoenix.Component

  alias ColorfulPandas.Auth.Identity

  attr :user, Identity, doc: "The currently logged in user"
  slot :navigation, required: true, doc: "Navigation items"

  def sidebar(assigns) do
    ~H"""
    <div class="hidden lg:fixed lg:inset-y-0 lg:z-50 lg:flex lg:w-72 lg:flex-col">
      <div class="flex grow flex-col gap-y-5 overflow-y-auto border-r border-black/10 bg-light-blue px-6 pb-4">
        <nav class="flex flex-1 flex-col">
          <ul role="list" class="flex flex-1 flex-col gap-y-7">
            <%= render_slot(@navigation) %>
            <li class="-mx-6 mt-auto">
              <span class="flex items-center gap-x-4 px-6 py-3 text-sm font-semibold leading-6 text-gray-900 hover:bg-gray-50">
                <img
                  class="h-8 w-8 rounded-full bg-gray-50"
                  src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80"
                  alt=""
                />
                <span class="sr-only">Your profile</span>
                <span aria-hidden="true"><%= @user.name %></span>
              </span>
            </li>
          </ul>
        </nav>
      </div>
    </div>
    """
  end

  attr :label, :string, required: true
  attr :patch, :string, default: nil
  attr :navigate, :string, default: nil
  attr :href, :string, default: nil

  def sidebar_item(assigns) do
    ~H"""
    <li>
      <!-- Current: "bg-gray-50 text-indigo-600", Default: "text-gray-700 hover:text-indigo-600 hover:bg-gray-50" -->
      <.link patch={@patch} navigate={@navigate} href={@href} class={["bg-gray-50 text-black group flex gap-x-3 rounded-md p-2 text-sm leading-6 font-semibold", "hover:bg-green"]}>
        <%= @label %>
      </.link>
    </li>
    """
  end
end
