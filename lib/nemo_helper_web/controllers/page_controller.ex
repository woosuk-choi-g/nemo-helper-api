defmodule NemoHelperWeb.PageController do
  use NemoHelperWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
