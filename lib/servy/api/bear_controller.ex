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

  @spec create(Conv.t(), map) :: Conv.t()
  def create(%Conv{} = conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end
end
