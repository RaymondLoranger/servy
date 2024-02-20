defmodule Servy.PledgeServerTest do
  use ExUnit.Case, async: false

  import ExUnit.CaptureIO

  alias Servy.PledgeServer

  doctest PledgeServer

  describe "PledgeServer.handle_info/2" do
    test "handles unexpected messages" do
      server_pid = Process.whereis(PledgeServer)
      # Can't touch this! {:stop, "hammertime"}
      send(server_pid, {:stop, "hammertime"})

      assert capture_io(fn ->
               PledgeServer.handle_info({:stop, "hammertime"}, :ok)
             end) =~
               ~s|Can't touch this! {:stop, "hammertime"}|
    end
  end

  describe "PledgeServer sequence" do
    test "sequentially" do
      # Force a restart as other tests may have created pledges.
      GenServer.stop(PledgeServer)
      # Give time to the supervisor to restart a pledge server.
      Process.sleep(100)
      assert PledgeServer.recent_pledges() == [{"wilma", 15}, {"fred", 25}]
      assert PledgeServer.create_pledge("larry", 10) =~ "pledge-"

      assert PledgeServer.recent_pledges() == [
               {"larry", 10},
               {"wilma", 15},
               {"fred", 25}
             ]

      :ok = PledgeServer.clear()
      assert PledgeServer.recent_pledges() == []
      :ok = PledgeServer.set_cache_size(4)
      PledgeServer.create_pledge("moe", 20)
      PledgeServer.create_pledge("curly", 30)
      PledgeServer.create_pledge("daisy", 40)
      PledgeServer.create_pledge("grace", 50)

      assert PledgeServer.recent_pledges() == [
               {"grace", 50},
               {"daisy", 40},
               {"curly", 30},
               {"moe", 20}
             ]

      assert PledgeServer.total_pledged() == 140
    end
  end
end
