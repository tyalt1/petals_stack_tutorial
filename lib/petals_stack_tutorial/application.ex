defmodule PetalsStackTutorial.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PetalsStackTutorialWeb.Telemetry,
      PetalsStackTutorial.Repo,
      {DNSCluster,
       query: Application.get_env(:petals_stack_tutorial, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PetalsStackTutorial.PubSub},
      # Start a worker by calling: PetalsStackTutorial.Worker.start_link(arg)
      # {PetalsStackTutorial.Worker, arg},
      # Start to serve requests, typically the last entry
      PetalsStackTutorialWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PetalsStackTutorial.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PetalsStackTutorialWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
