defmodule Servy.HibernateController do
  alias Servy.Conv

  @spec show(Conv.t()) :: Conv.t()
  def show(%Conv{method: "GET", path: "/hibernate/" <> time} = conv) do
    body = """
    <div style="font-family: Verdana; font-size: 20px; font-weight: bold;">
    Awake
    </div>
    """

    time |> String.to_integer() |> Process.sleep()
    %Conv{conv | status: 200, resp_body: body}
  end
end
