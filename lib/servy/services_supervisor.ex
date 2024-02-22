defmodule Servy.ServicesSupervisor do
  use Supervisor

  alias __MODULE__
  alias Servy.{PledgeServer, SensorServer}

  @spec start_link(term) :: Supervisor.on_start()
  def start_link(:ok) do
    IO.ANSI.Plus.puts([
      :chartreuse_yellow,
      "Starting the services supervisor..."
    ])

    Supervisor.start_link(ServicesSupervisor, :ok, name: ServicesSupervisor)
  end

  ## Callbacks

  @spec init(term) ::
          {:ok, {:supervisor.sup_flags(), [:supervisor.child_spec()]}} | :ignore
  def init(:ok) do
    [
      {PledgeServer, :ok},
      # refresh lapse in minutes -- between 1 and 120
      {SensorServer, 3}
    ]
    |> Supervisor.init(strategy: :one_for_one)
  end
end
