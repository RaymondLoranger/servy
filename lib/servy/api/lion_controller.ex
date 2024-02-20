defmodule Servy.Api.LionController do
  use PersistConfig

  alias Servy.Conv

  @app_json "application/json"
  @lions get_env(:lions)
  @json Poison.encode!(@lions)

  @spec index(Conv.t()) :: Conv.t()
  def index(%Conv{} = conv) do
    %Conv{conv | status: 200, resp_content_type: @app_json, resp_body: @json}
  end
end
