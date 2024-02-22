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

  @spec get_http_server :: GenServer.name()
  def get_http_server, do: GenServer.call(KickStarter, :get_http_server)

  ## Callbacks

  @spec init(:ok) :: {:ok, pid}
  def init(:ok) do
    Process.flag(:trap_exit, true)
    http_server_pid = start_http_server()
    {:ok, http_server_pid}
  end

  @spec handle_call(atom, GenServer.from(), pid) :: {:reply, pid, pid}
  def handle_call(:get_http_server, _from, http_server_pid),
    do: {:reply, http_server_pid, http_server_pid}

  @spec handle_info(tuple, pid) :: {:noreply, pid}
  def handle_info({:EXIT, _pid, reason} = exit, http_server_pid) do
    IO.ANSI.Plus.puts([:pink_flamingo, "Exit trapped => #{inspect(exit)}"])

    IO.ANSI.Plus.puts([
      :pink_flamingo,
      "HttpServer ",
      :deep_pink,
      "(==> #{inspect(http_server_pid)})",
      :pink_flamingo,
      " exited (#{inspect(reason)})"
    ])

    http_server_pid = start_http_server()
    {:noreply, http_server_pid}
  end

  ## Private functions

  @spec start_http_server :: pid
  defp start_http_server do
    IO.ANSI.Plus.puts([:chartreuse_yellow, "Starting the HTTP server..."])
    port = get_env(:port)
    http_server_pid = spawn_link(HttpServer, :start, [port])
    Process.register(http_server_pid, HttpServer)
    http_server_pid
  end
end
