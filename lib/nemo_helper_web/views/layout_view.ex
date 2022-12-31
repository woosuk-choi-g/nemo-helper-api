defmodule NemoHelperWeb.LayoutView do
  use NemoHelperWeb, :view

  # Phoenix LiveDashboard is available only in development by default,
  # so we instruct Elixir to not warn if the dashboard route is missing.
  @compile {:no_warn_undefined, {Routes, :live_dashboard_path, 2}}

  def title() do
    "Awesome title!"
  end
end
