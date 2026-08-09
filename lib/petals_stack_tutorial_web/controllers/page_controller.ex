defmodule PetalsStackTutorialWeb.PageController do
  use PetalsStackTutorialWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
