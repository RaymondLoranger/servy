defmodule Servy.Api.BearController do
  alias Servy.{Conv, Wildthings, BearController}

  @app_json "application/json"

  @spec index(Conv.t()) :: Conv.t()
  def index(%Conv{} = conv) do
    body = Wildthings.list_bears() |> Poison.encode!()
    %Conv{conv | status: 200, resp_content_type: @app_json, resp_body: body}
  end

  @spec create(Conv.t(), map) :: Conv.t()
  defdelegate create(conv, params), to: BearController
  # def create(%Conv{} = conv, %{"name" => name, "type" => type} = _params) do
  #   %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  # end
end
