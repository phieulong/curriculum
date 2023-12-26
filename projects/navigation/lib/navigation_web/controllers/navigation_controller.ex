defmodule NavigationWeb.NavigationController do
  use NavigationWeb, :controller

  def home(conn, _params) do
    render(conn, :home, [])
  end

  def about(conn, _params) do
    render(conn, :about, [])
  end

  def projects(conn, _params) do
    render(conn, :projects, [])
  end
end
