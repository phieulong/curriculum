defmodule RandomNumberWeb.RandomNumberController do
  use RandomNumberWeb, :controller

  def random(conn, _params) do
    render(conn, :random_number, random_number: Enum.random(1..100))
  end
end
