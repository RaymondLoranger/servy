defmodule Servy.PledgeServer do
  use GenServer

  alias __MODULE__

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  ## Client interface

  def start_link(:ok) do
    IO.ANSI.Plus.puts([:baby_blue, "\nStarting the pledge server..."])
    GenServer.start_link(PledgeServer, %State{}, name: PledgeServer)
  end

  def create_pledge(name, amount),
    do: GenServer.call(PledgeServer, {:create_pledge, name, amount})

  def recent_pledges, do: GenServer.call(PledgeServer, :recent_pledges)

  def total_pledged, do: GenServer.call(PledgeServer, :total_pledged)

  def clear, do: GenServer.cast(PledgeServer, :clear)

  def set_cache_size(size),
    do: GenServer.cast(PledgeServer, {:set_cache_size, size})

  ## Server callbacks

  def init(state),
    do: {:ok, put_in(state.pledges, fetch_recent_pledges_from_service())}

  def handle_cast(:clear, state), do: {:noreply, put_in(state.pledges, [])}

  def handle_cast({:set_cache_size, size}, state) do
    resized_cache = Enum.take(state.pledges, size)
    {:noreply, %State{state | cache_size: size, pledges: resized_cache}}
  end

  def handle_call(:total_pledged, _from, state) do
    # total = Enum.map(state.pledges, &elem(&1, 1)) |> Enum.sum()
    total = for({_name, amount} <- state.pledges, do: amount) |> Enum.sum()
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, state),
    do: {:reply, state.pledges, state}

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    {:reply, id, put_in(state.pledges, cached_pledges)}
  end

  def handle_info(message, state) do
    IO.ANSI.Plus.puts([:indian_red, "\nCan't touch this! #{inspect(message)}"])
    {:noreply, state}
  end

  ## Private functions

  defp send_pledge_to_service(_name, _amount) do
    # CODE GOES HERE TO SEND PLEDGE TO EXTERNAL SERVICE
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    # CODE GOES HERE TO FETCH RECENT PLEDGES FROM EXTERNAL SERVICE

    # Example return value:
    [{"wilma", 15}, {"fred", 25}]
  end
end

# alias Servy.PledgeServer

# {:ok, pid} = PledgeServer.start_link(:ok)
# send(pid, {:stop, "hammertime"})
# PledgeServer.set_cache_size(4)

# IO.ANSI.Plus.puts([
#   :islamic_green,
#   PledgeServer.create_pledge("larry", 10) |> inspect()
# ])

# PledgeServer.clear()
# IO.inspect PledgeServer.create_pledge("moe", 20)
# IO.inspect PledgeServer.create_pledge("curly", 30)
# IO.inspect PledgeServer.create_pledge("daisy", 40)
# IO.inspect PledgeServer.create_pledge("grace", 50)
# IO.ANSI.Plus.puts([:lawn_green, PledgeServer.recent_pledges() |> inspect()])
# IO.ANSI.Plus.puts([:lawn_green, PledgeServer.total_pledged() |> inspect()])
