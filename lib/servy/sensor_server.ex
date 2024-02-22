defmodule Servy.SensorServer do
  use GenServer

  alias __MODULE__
  alias Servy.{Tracker, VideoCam}

  @timeout :timer.seconds(5)
  @default_refresh_lapse_in_min 5

  defmodule State do
    defstruct sensor_data: %{}, refresh_lapse_in_min: nil
  end

  ## Client interface

  @spec start_link(non_neg_integer) :: GenServer.on_start()
  def start_link(refresh_lapse_in_min \\ @default_refresh_lapse_in_min)
      when refresh_lapse_in_min in 1..120 do
    IO.ANSI.Plus.puts([
      :baby_blue,
      "Starting the sensor server with #{refresh_lapse_in_min} min refresh..."
    ])

    GenServer.start_link(SensorServer, refresh_lapse_in_min, name: SensorServer)
  end

  @spec get_sensor_data :: map
  def get_sensor_data, do: GenServer.call(SensorServer, :get_sensor_data)

  @spec get_refresh_lapse :: String.t()
  def get_refresh_lapse, do: GenServer.call(SensorServer, :get_refresh_lapse)

  def set_refresh_lapse(lapse_in_min),
    do: GenServer.cast(SensorServer, {:set_refresh_lapse, lapse_in_min})

  ## Server callbacks

  @spec init(pos_integer) :: {:ok, map}
  def init(lapse) do
    schedule_refresh(lapse)
    {:ok, %State{sensor_data: sensor_data(), refresh_lapse_in_min: lapse}}
  end

  @spec handle_call(atom, GenServer.from(), map) ::
          {:reply, map | String.t(), map}
  def handle_call(:get_sensor_data, _from, state),
    do: {:reply, state.sensor_data, state}

  def handle_call(:get_refresh_lapse, _from, state),
    do: {:reply, "#{state.refresh_lapse_in_min} min", state}

  @spec handle_cast(tuple, map) :: {:noreply, map}
  def handle_cast({:set_refresh_lapse, lapse}, state) when lapse in 1..120,
    do: {:noreply, put_in(state.refresh_lapse_in_min, lapse)}

  @spec handle_info(atom, map) :: {:noreply, map}
  def handle_info(:refresh, %State{refresh_lapse_in_min: lapse} = state) do
    IO.puts("Refreshing the cache...")
    schedule_refresh(lapse)
    {:noreply, put_in(state.sensor_data, sensor_data())}
  end

  def handle_info(message, state) do
    IO.ANSI.Plus.puts([:indian_red, "\nCan't touch this! #{inspect(message)}"])
    {:noreply, state}
  end

  ## Private functions

  @spec sensor_data :: map
  defp sensor_data do
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

  @spec schedule_refresh(pos_integer) :: reference
  defp schedule_refresh(lapse),
    do: Process.send_after(self(), :refresh, :timer.minutes(lapse))
end
