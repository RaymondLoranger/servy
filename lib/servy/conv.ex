defmodule Servy.Conv do
  @moduledoc "A conversation struct and functions."

  alias __MODULE__

  defstruct method: "",
            path: "",
            params: %{},
            headers: %{},
            assigns: %{},
            resp_content_type: "text/html",
            resp_body: "",
            status: nil

  @type t :: %Conv{
          method: String.t(),
          path: String.t(),
          params: map,
          headers: map,
          assigns: map,
          resp_content_type: String.t(),
          resp_body: String.t(),
          status: non_neg_integer | nil
        }

  @spec full_status(t) :: String.t()
  def full_status(%Conv{status: status} = _conv), do: http_status_code(status)

  @spec assign(t, atom, term) :: t
  def assign(%Conv{assigns: assigns} = conv, key, value) when is_atom(key),
    do: %{conv | assigns: put_in(assigns[key], value)}

  ## Private functions

  @spec http_status_code(non_neg_integer) :: String.t()
  defp http_status_code(status)
  defp http_status_code(200), do: "200 OK"
  defp http_status_code(201), do: "201 Created"
  defp http_status_code(401), do: "401 Unauthorized"
  defp http_status_code(403), do: "403 Forbidden"
  defp http_status_code(404), do: "404 Not Found"
  defp http_status_code(500), do: "500 Internal Server Error"
  defp http_status_code(code), do: "#{inspect(code)} Unknown Error"
end
