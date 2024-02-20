defmodule Servy.Handler do
  @moduledoc "Handles HTTP requests."

  use PersistConfig

  alias Servy.Api.BearController, as: ApiBearController
  alias Servy.Api.LionController, as: ApiLionController

  alias Servy.{
    BearController,
    LionController,
    HibernateController,
    Conv,
    Parser,
    PledgeController,
    Plugins,
    SensorController,
    WildthingsController
  }

  @about_path get_env(:about_path)
  @pages_path get_env(:pages_path)
  @bear_form_path get_env(:bear_form_path)

  @doc "Transforms the request into a response."
  @spec handle(String.t()) :: String.t()
  def handle(request) do
    request
    |> Parser.parse()
    |> Plugins.rewrite_path()
    |> Plugins.log("Conversation before routing:")
    |> route
    |> Plugins.emojify()
    |> Plugins.track()
    |> Plugins.log("Conversation before response:")
    |> format_response
  end

  @spec route(Conv.t()) :: Conv.t()
  def route(%Conv{method: "POST", path: "/pledges", params: params} = conv),
    do: PledgeController.create(conv, params)

  def route(%Conv{method: "GET", path: "/pledges"} = conv),
    do: PledgeController.index(conv)

  def route(%Conv{method: "GET", path: "/sensors"} = conv),
    do: SensorController.index(conv)

  def route(%Conv{method: "GET", path: "/kaboom"} = _conv), do: raise("Kaboom!")

  def route(%Conv{method: "GET", path: "/hibernate/" <> _time} = conv),
    do: HibernateController.show(conv)

  def route(%Conv{method: "GET", path: "/wildthings"} = conv),
    do: WildthingsController.index(conv)

  def route(%Conv{method: "GET", path: "/api/bears"} = conv),
    do: ApiBearController.index(conv)

  def route(%Conv{method: "GET", path: "/api/lions"} = conv),
    do: ApiLionController.index(conv)

  def route(%Conv{method: "GET", path: "/bears"} = conv),
    do: conv |> Conv.assign(:title, "All the Bears!") |> BearController.index()

  def route(%Conv{method: "GET", path: "/lions"} = conv),
    do: LionController.index(conv)

  def route(%Conv{method: "GET", path: "/bears/new"} = conv),
    do: @bear_form_path |> File.read() |> handle_file(conv)

  def route(%Conv{method: "GET", path: "/bears/" <> id} = conv),
    do: BearController.show(conv, Map.put(conv.params, "id", id))

  def route(%Conv{method: "GET", path: "/lions/" <> id} = conv),
    do: LionController.show(conv, Map.put(conv.params, "id", id))

  def route(%Conv{method: "DELETE", path: "/bears/" <> _id} = conv),
    do: %{conv | status: 403, resp_body: "Deleting a bear is forbidden!"}

  def route(%Conv{method: "DELETE", path: "/lions/" <> _id} = conv),
    do: %{conv | status: 403, resp_body: "Deleting a lion is forbidden!"}

  def route(%Conv{method: "GET", path: "/about"} = conv),
    do: @about_path |> File.read() |> handle_file(conv)

  def route(%Conv{method: "GET", path: "/pages/" <> file} = conv) do
    @pages_path |> Path.join("#{file}.html") |> File.read() |> handle_file(conv)
  end

  # name=Baloo&type=Brown
  def route(%Conv{method: "POST", path: "/bears", params: params} = conv),
    do: BearController.create(conv, params)

  # name=Leo&type=Iconic
  def route(%Conv{method: "POST", path: "/lions", params: params} = conv),
    do: LionController.create(conv, params)

  def route(%Conv{method: "GET", path: "/error/closed"} = conv),
    do: %{conv | status: 500, resp_body: "socket closed"}

  def route(%Conv{method: "GET", path: "/error/einval"} = conv),
    do: %{conv | status: 500, resp_body: "socket not in passive mode"}

  def route(%Conv{method: "GET", path: "/error/" <> reason} = conv),
    do: %{conv | status: 500, resp_body: "POSIX error #{reason}"}

  def route(%Conv{path: path} = conv),
    do: %Conv{conv | status: 404, resp_body: "No #{path} here!"}

  @spec format_response(Conv.t()) :: String.t()
  def format_response(%{resp_content_type: type, resp_body: body} = conv) do
    # charset=utf-8 allows to properly display emojies.
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{type}; charset=utf-8\r
    Content-Length: #{byte_size(body)}\r
    \r
    #{body}
    """
  end

  ## Private functions

  @spec handle_file(tuple, Conv.t()) :: Conv.t()
  defp handle_file({:ok, content}, conv),
    do: %Conv{conv | status: 200, resp_body: content}

  defp handle_file({:error, :enoent}, conv),
    do: %Conv{conv | status: 404, resp_body: "File not found!"}

  defp handle_file({:error, reason}, conv),
    do: %Conv{conv | status: 500, resp_body: "File error: #{reason}"}
end
