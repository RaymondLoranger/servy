defmodule Servy.SensorController do
  alias Servy.{Conv, SensorServer}

  @spec index(Conv.t()) :: Conv.t()
  def index(conv) do
    body = """
    <pre style="font-family: Consolas; font-size: 20px; font-weight: bold;">
    #{SensorServer.get_sensor_data() |> inspect(pretty: true)}
    </pre>
    """

    %{conv | status: 200, resp_body: body}
  end
end
