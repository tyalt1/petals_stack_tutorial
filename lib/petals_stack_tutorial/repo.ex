defmodule PetalsStackTutorial.Repo do
  use Ecto.Repo,
    otp_app: :petals_stack_tutorial,
    adapter: Ecto.Adapters.Postgres
end
