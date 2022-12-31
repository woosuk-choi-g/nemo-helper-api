defmodule NemoHelperWeb.PageController do
  use NemoHelperWeb, :controller

  def index(conn, _params) do
    conn
    |> put_flash(:info, "welcome to Phoenix, from flash info!")
    |> put_flash(:error, "Let's pretend we have a error.")
    |> render("index.html")
  end
end
