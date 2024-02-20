defmodule Servy.TopSupervisor do
  use Application

  alias __MODULE__
  alias Servy.{KickStarter, ServicesSupervisor}

  @spec start(Application.start_type(), term) :: {:ok, pid}
  def start(_start_type, :ok = _start_args) do
    IO.ANSI.Plus.puts([:dark_orange, "Starting the servy application..."])
    IO.ANSI.Plus.puts([:dark_orange, "Starting the top supervisor..."])

    [
      {KickStarter, :ok},
      {ServicesSupervisor, :ok}
    ]
    |> Supervisor.start_link(name: TopSupervisor, strategy: :one_for_one)
  end
end
