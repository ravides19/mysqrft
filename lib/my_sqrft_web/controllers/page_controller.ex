defmodule MySqrftWeb.PageController do
  use MySqrftWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
