defmodule Servy.Api.LionController do
  alias Servy.{Conv, Wildthings}

  @app_json "application/json"

  @spec index(Conv.t()) :: Conv.t()
  def index(%Conv{} = conv) do
    body = Wildthings.list_lions() |> Poison.encode!()
    %Conv{conv | status: 200, resp_content_type: @app_json, resp_body: body}
  end
end
