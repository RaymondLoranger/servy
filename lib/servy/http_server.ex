defmodule Servy.HttpServer do
  alias Servy.Handler

  @doc """
  Starts the server on the given `port` of localhost e.g. localhost:3000.
  """
  @spec start(non_neg_integer) :: no_return
  def start(port) when is_integer(port) and port > 1023 do
    # Socket options (don't worry about these details):
    # `:binary` - open the socket in "binary" mode and deliver data as binaries
    # `backlog: 10` - increase backlog queue maximum size from 5 to 10
    # `packet: :raw` - deliver entire binary without doing any packet handling
    # `active: false` - receive data when ready by calling `:gen_tcp.recv/2`
    # `reuseaddr: true` - allows reusing the address if the listener crashes
    options = [
      :binary,
      backlog: 10,
      packet: :raw,
      active: false,
      reuseaddr: true
    ]

    # Creates a socket to listen for client connections.
    # `listen_socket` is bound to the listening socket.
    {:ok, listen_socket} = :gen_tcp.listen(port, options)

    IO.ANSI.Plus.puts([
      :islamic_green,
      "\n🎧  Listening for connection requests on port #{port}...\n"
    ])

    accept_loop(listen_socket)
  end

  ## Private functions

  # @doc """
  # Accepts client connections on the `listen_socket`.
  # """
  @spec accept_loop(:gen_tcp.socket()) :: no_return
  defp accept_loop(listen_socket) do
    IO.ANSI.Plus.puts([
      :islamic_green,
      "🕐  Waiting to accept a client connection...\n
    "
    ])

    # Suspends (blocks) and waits for a client connection. When a connection
    # is accepted, `client_socket` is bound to a new client socket.
    {:ok, client_socket} = :gen_tcp.accept(listen_socket)
    IO.ANSI.Plus.puts([:islamic_green, "⚡️  Connection accepted!\n"])
    # Receives the request and sends a response over the client socket.
    spawn(fn -> serve(client_socket) end)

    # Loop back to wait and accept the next connection.
    accept_loop(listen_socket)
  end

  # @doc """
  # Receives the request on the `client_socket` and
  # sends a response back over the same socket.
  # """
  @spec serve(:gen_tcp.socket()) :: :ok
  defp serve(client_socket) do
    IO.ANSI.Plus.puts([:tenn, "#{self() |> inspect()}: working on request..."])

    client_socket
    |> read_request()
    |> Handler.handle()
    |> write_response(client_socket)
  end

  # @doc """
  # Receives a request on the `client_socket`.
  # """
  @spec read_request(:gen_tcp.socket()) :: String.t()
  defp read_request(client_socket) do
    # 0 => all available bytes
    request =
      case :gen_tcp.recv(client_socket, 0) do
        {:ok, request} -> request
        {:error, reason} -> error_request(reason)
      end

    IO.ANSI.Plus.puts([:islamic_green, "\n➡️  Received request:"])
    IO.puts(request)
    request
  end

  @spec error_request(atom) :: String.t()
  defp error_request(reason) do
    """
    GET /error/#{reason} HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
  end

  # @doc """
  # Sends the `response` over the `client_socket`.
  # """
  @spec write_response(String.t(), :gen_tcp.socket()) :: :ok
  defp write_response(response, client_socket) do
    :gen_tcp.send(client_socket, response) |> write_send_result()
    IO.puts(response)
    # Closes the client socket, ending the connection.
    # Does not close the listen socket!
    :gen_tcp.close(client_socket)
  end

  defp write_send_result(:ok),
    do: IO.ANSI.Plus.puts([:islamic_green, "\n⬅️  Response sent:"])

  defp write_send_result({:error, :closed}) do
    IO.ANSI.Plus.puts([
      :fuchsia,
      "\n𝍐  Response not sent (socket closed):"
    ])
  end

  defp write_send_result({:error, :einval}) do
    IO.ANSI.Plus.puts([
      :fuchsia,
      "\n𝍐  Response not sent (socket not in passive mode):"
    ])
  end

  defp write_send_result({:error, reason}) do
    IO.ANSI.Plus.puts([
      :fuchsia,
      "\n𝍐  Response not sent (POSIX error #{reason}):"
    ])
  end
end
