defmodule Servy.Plugins do
  alias Servy.Conv

  require Logger

  @emojies String.duplicate("🎉", 5)

  @doc "Logs 404 requests"
  @spec track(Conv.t()) :: Conv.t()
  def track(%Conv{status: 404, path: path} = conv) do
    unless Mix.env() == :test,
      do: Logger.warning("Warning: #{path} is on the loose!")

    conv
  end

  def track(%Conv{} = conv), do: conv

  @spec rewrite_path(Conv.t()) :: Conv.t()
  def rewrite_path(%Conv{path: "/wildlife"} = conv),
    do: %Conv{conv | path: "/wildthings"}

  # A specific 'rewrite_path' function
  # def rewrite_path(%Conv{path: "/bears?id=" <> id} = conv),
  #   do: %Conv{conv | path: "/bears/#{id}"}

  # A generic 'rewrite_path' function
  def rewrite_path(%{path: path} = conv) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    # "/bears?id=123" => %{"thing" => "bears, "id" => "123"}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(conv, captures)
  end

  # def rewrite_path(%Conv{} = conv), do: conv

  @spec emojify(Conv.t()) :: Conv.t()
  def emojify(%Conv{status: 200, resp_content_type: "text/html"} = conv),
    do: %{conv | resp_body: "#{@emojies}\n#{conv.resp_body}\n#{@emojies}"}

  def emojify(%Conv{} = conv), do: conv

  @spec log(Conv.t(), String.t()) :: Conv.t()
  def log(%Conv{} = conv, heading) do
    if Mix.env() == :dev do
      # :pretty allows each key-value pair to be on a separate line.
      IO.ANSI.Plus.puts([
        :chartreuse,
        "#{heading}\n",
        :aqua,
        "#{inspect(conv, pretty: true)}"
      ])
    end

    conv
  end

  ## Private functions

  @spec rewrite_path_captures(Conv.t(), map) :: Conv.t()
  defp rewrite_path_captures(conv, %{"thing" => thing, "id" => id}) do
    %{conv | path: "/#{thing}/#{id}"}
  end

  defp rewrite_path_captures(conv, nil), do: conv
end
