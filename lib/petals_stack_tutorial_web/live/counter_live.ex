defmodule PetalsStackTutorialWeb.CounterLive do
  use PetalsStackTutorialWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter: 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center min-h-screen bg-gray-50">
      <h1 class="text-3xl font-bold text-gray-800 mb-6">The count is: {@counter}</h1>

      <div class="flex gap-4">
        <button
          phx-click="dec"
          class="px-6 py-2 bg-rose-500 hover:bg-rose-600 text-white font-semibold rounded-lg shadow transition duration-200"
        >
          -
        </button>
        <button
          phx-click="inc"
          class="px-6 py-2 bg-emerald-500 hover:bg-emerald-600 text-white font-semibold rounded-lg shadow transition duration-200"
        >
          +
        </button>
      </div>
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
