defmodule Servy.LionController do
  alias Servy.{Lion, LionView, Conv, Wildthings}

  @vowels [?a, ?e, ?i, ?o, ?u, ?A, ?E, ?I, ?O, ?U]

  @spec index(Conv.t()) :: Conv.t()
  def index(%Conv{} = conv) do
    lions = Wildthings.list_lions() |> Enum.sort(Lion)
    render(conv, :index, lions: lions)
  end

  @spec show(Conv.t(), map) :: Conv.t()
  def show(%Conv{} = conv, %{"id" => id} = _params) do
    render(conv, :show, lion: Wildthings.get_lion(id))
  end

  @spec create(Conv.t(), map) :: Conv.t()
  def create(
        %Conv{} = conv,
        %{"name" => name, "type" => <<first::8, _etc::binary>> = type} = _params
      )
      when first in @vowels do
    %{conv | status: 201, resp_body: "Created an #{type} lion named #{name}!"}
  end

  def create(%Conv{} = conv, %{"name" => name, "type" => type}) do
    %{conv | status: 201, resp_body: "Created a #{type} lion named #{name}!"}
  end

  ## Private functions

  @spec render(Conv.t(), function :: atom, Keyword.t()) :: Conv.t()
  # defp render(conv, function, bindings) do
  #   assigns = Map.merge(assigns, Map.new(bindings))
  #   %{conv | status: 200, resp_body: apply(LionView, function, [assigns])}
  # end

  defp render(%Conv{assigns: assigns} = conv, :index, bindings) do
    assigns = Map.merge(assigns, Map.new(bindings))
    %{conv | status: 200, resp_body: LionView.index(assigns)}
  end

  defp render(%Conv{assigns: assigns} = conv, :show, bindings) do
    assigns = Map.merge(assigns, Map.new(bindings))
    %{conv | status: 200, resp_body: LionView.show(assigns)}
  end
end
