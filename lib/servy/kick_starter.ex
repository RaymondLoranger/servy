defmodule Servy.KickStarter do
  use GenServer
  use PersistConfig

  alias __MODULE__
  alias Servy.HttpServer

  ## API

  @spec start_link(term) :: GenServer.on_start()
  def start_link(:ok) do
    IO.ANSI.Plus.puts([:chartreuse_yellow, "Starting the kickstarter..."])
    GenServer.start_link(KickStarter, :ok, name: KickStarter)
  end

  ## Callbacks

  @spec init(:ok) :: {:ok, pid}
  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_http_server()
    {:ok, server_pid}
  end

  @spec handle_info(tuple, pid) :: {:noreply, pid}
  def handle_info({:EXIT, _pid, reason} = exit, server_pid) do
    IO.ANSI.Plus.puts([:pink_flamingo, "Exit trapped => #{inspect(exit)}"])

    IO.ANSI.Plus.puts([
      :pink_flamingo,
      "HttpServer ",
      :deep_pink,
      "(==> #{inspect(server_pid)})",
      :pink_flamingo,
      " exited (#{inspect(reason)})"
    ])

    server_pid = start_http_server()
    {:noreply, server_pid}
  end

  ## Private functions

  @spec start_http_server :: pid
  defp start_http_server do
    IO.ANSI.Plus.puts([:chartreuse_yellow, "Starting the HTTP server..."])
    port = get_env(:port)
    server_pid = spawn_link(HttpServer, :start, [port])
    Process.register(server_pid, HttpServer)
    server_pid
  end
end
