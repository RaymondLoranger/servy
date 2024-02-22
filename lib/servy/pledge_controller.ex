defmodule Servy.PledgeController do
  alias Servy.{Conv, PledgeServer}

  @spec create(Conv.t(), %{String.t() => String.t()}) :: Conv.t()
  def create(conv, %{"name" => name, "amount" => amount}) do
    # Sends the pledge to the external service and caches it.
    PledgeServer.create_pledge(name, String.to_float(amount))

    body = """
    <div>
    #{name} pledged #{amount}!
    </div>
    """

    %{conv | status: 201, resp_body: body}
  end

  @spec index(Conv.t()) :: Conv.t()
  def index(conv) do
    # Gets the recent pledges from the cache.
    body = """
    <pre style="font-family: Consolas; font-size: 20px; font-weight: bold;">
    #{PledgeServer.recent_pledges() |> inspect(pretty: true)}
    </pre>
    """

    %{conv | status: 200, resp_body: body}
  end
end
