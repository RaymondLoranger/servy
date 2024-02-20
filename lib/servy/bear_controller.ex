defmodule Servy.BearController do
  alias Servy.{Bear, BearView, Conv, Wildthings}

  @spec index(Conv.t()) :: Conv.t()
  def index(%Conv{} = conv) do
    bears = Wildthings.list_bears() |> Enum.sort(Bear)
    conv = Conv.assign(conv, :count, length(bears))
    render(conv, :index, bears: bears)
  end

  @spec show(Conv.t(), map) :: Conv.t()
  def show(%Conv{} = conv, %{"id" => id} = _params) do
    render(conv, :show, bear: Wildthings.get_bear(id))
  end

  @spec create(Conv.t(), map) :: Conv.t()
  def create(%Conv{} = conv, %{"name" => name, "type" => type} = _params) do
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end

  ## Private functions

  @spec render(Conv.t(), function :: atom, Keyword.t()) :: Conv.t()
  # defp render(conv, function, bindings) do
  #   assigns = Map.merge(assigns, Map.new(bindings))
  #   %{conv | status: 200, resp_body: apply(BearView, function, [assigns])}
  # end

  defp render(%Conv{assigns: assigns} = conv, :index, bindings) do
    assigns = Map.merge(assigns, Map.new(bindings))
    %{conv | status: 200, resp_body: BearView.index(assigns)}
  end

  defp render(%Conv{assigns: assigns} = conv, :show, bindings) do
    assigns = Map.merge(assigns, Map.new(bindings))
    %{conv | status: 200, resp_body: BearView.show(assigns)}
  end
end
