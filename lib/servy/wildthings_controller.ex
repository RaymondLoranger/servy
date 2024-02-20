defmodule Servy.WildthingsController do
  alias Servy.Conv

  @spec index(Conv.t()) :: Conv.t()
  def index(%Conv{method: "GET", path: "/wildthings"} = conv) do
    body = """
    <div>
    Bears, Lions, Tigers
    </div>
    """

    %Conv{conv | status: 200, resp_body: body}
  end
end
