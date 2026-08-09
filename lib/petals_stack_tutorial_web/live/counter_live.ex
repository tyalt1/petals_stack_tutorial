defmodule PetalsStackTutorialWeb.CounterLive do
  use PetalsStackTutorialWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter: 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Counter is {@counter}</h1>
      <button phx-click="inc" phx-debounce="20">+</button>
      <button phx-click="dec" phx-debounce="20">-</button>
    </div>
    """
  end

  @impl true
  def handle_event("inc", _payload, socket) do
    {:noreply, update(socket, :counter, fn x -> x + 1 end)}
  end

  def handle_event("dec", _payload, socket) do
    f = fn
      0 -> 0
      x -> x - 1
    end

    {:noreply, update(socket, :counter, f)}
  end
end
