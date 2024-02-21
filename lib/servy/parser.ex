defmodule Servy.Parser do
  alias Servy.Conv

  @url_encoded "application/x-www-form-urlencoded"
  @app_json "application/json"

  @doc ~S'''
  Parses a request into a conv struct.

  ## Examples

      iex> alias Servy.{Conv, Parser}
      iex> request = """
      ...> DELETE /some/path HTTP/1.1\r
      ...> \r
      ...> """
      iex> Parser.parse(request)
      %Conv{method: "DELETE", path: "/some/path", params: %{}}

      iex> alias Servy.{Conv, Parser}
      iex> request = """
      ...> POST /bears HTTP/1.1\r
      ...> Host: example.com\r
      ...> User-Agent: ExampleBrowser/1.0\r
      ...> Accept: */*\r
      ...> Content-Type: application/x-www-form-urlencoded\r
      ...> Content-Length: 21\r
      ...> \r
      ...> name=Baloo&type=Brown
      ...> """
      iex> Parser.parse(request)
      %Conv{
        method: "POST",
        path: "/bears",
        params: %{"name" => "Baloo", "type" => "Brown"}
      }
  '''
  @spec parse(String.t()) :: Conv.t()
  def parse(request) do
    [top_lines, params_string] = String.split(request, "\r\n\r\n")
    [request_line | header_lines] = String.split(top_lines, "\r\n")
    [method, path, _version] = String.split(request_line, " ")
    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params_string)
    %Conv{method: method, path: path, params: params}
  end

  ## Private functions

  @spec parse_headers([String.t()]) :: %{String.t() => String.t()}
  defp parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn header_line, acc ->
      [key, value] = String.split(header_line, ": ")
      put_in(acc[key], value)
    end)
  end

  @spec parse_params(String.t(), String.t()) :: %{String.t() => String.t()}
  defp parse_params(@url_encoded = _content_type, params_string),
    do: params_string |> String.trim() |> URI.decode_query()

  defp parse_params(@app_json = _content_type, params_string),
    do: Poison.Parser.parse!(params_string)

  defp parse_params(_content_type, _params_string), do: %{}
end
