defmodule Servy.SensorServer do
  use GenServer

  alias __MODULE__
  alias Servy.{Tracker, VideoCam}

  @timeout :timer.seconds(5)

  ## Client interface

  @spec start_link(non_neg_integer) :: GenServer.on_start()
  def start_link(refresh_lapse) when refresh_lapse in 1..120 do
    IO.ANSI.Plus.puts([
      :baby_blue,
      "Starting the sensor server with #{refresh_lapse} min refresh..."
    ])

    GenServer.start_link(SensorServer, refresh_lapse, name: SensorServer)
  end

  @spec get_sensor_data :: map
  def get_sensor_data, do: GenServer.call(SensorServer, :get_sensor_data)

  ## Server callbacks

  @spec init(non_neg_integer) :: {:ok, map}
  def init(lapse) do
    schedule_refresh(lapse)
    {:ok, run_tasks_to_get_sensor_data()}
  end

  @spec handle_info(tuple, map) :: {:noreply, map}
  def handle_info({:refresh, lapse}, _state) do
    IO.puts("Refreshing the cache...")
    schedule_refresh(lapse)
    {:noreply, run_tasks_to_get_sensor_data()}
  end

  @spec handle_call(atom, GenServer.from(), map) :: {:reply, map, map}
  def handle_call(:get_sensor_data, _from, state), do: {:reply, state, state}

  ## Private functions

  @spec run_tasks_to_get_sensor_data :: map
  defp run_tasks_to_get_sensor_data do
    IO.ANSI.Plus.puts([
      :chartreuse_yellow,
      "Running tasks to get sensor data..."
    ])

    task = Task.async(Tracker, :get_location, ["bigfoot"])

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(VideoCam, :get_snapshot, [&1]))
      |> Enum.map(&Task.await(&1, @timeout))

    bigfoot_loc = Task.await(task, @timeout)
    %{snapshots: snapshots, location: bigfoot_loc}
  end

  @spec schedule_refresh(non_neg_integer) :: reference
  defp schedule_refresh(lapse),
    do: Process.send_after(self(), {:refresh, lapse}, :timer.minutes(lapse))
end
