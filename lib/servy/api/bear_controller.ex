defmodule Servy.Api.BearController do
  use PersistConfig

  alias Servy.Conv

  @app_json "application/json"
  @bears get_env(:bears)
  @json Poison.encode!(@bears)

  @spec index(Conv.t()) :: Conv.t()
  def index(%Conv{} = conv) do
    %Conv{conv | status: 200, resp_content_type: @app_json, resp_body: @json}
  end
end
