defmodule Servy.Bear do
  alias __MODULE__

  defstruct id: nil,
            name: "",
            type: "",
            hibernating: false

  @type t :: %Bear{
          id: non_neg_integer | nil,
          name: String.t(),
          type: String.t(),
          hibernating: boolean
        }

  @spec is_grizzly(t) :: boolean
  def is_grizzly(bear), do: bear.type == "Grizzly"

  @spec order_asc_by_name(t, t) :: boolean
  def order_asc_by_name(b1, b2), do: b1.name <= b2.name

  @spec compare(t, t) :: :lt | :eq | :gt
  def compare(%Bear{} = bear1, %Bear{} = bear2) do
    %{name: name1, type: type1, hibernating: hiber1, id: id1} = bear1
    %{name: name2, type: type2, hibernating: hiber2, id: id2} = bear2

    case {{name1, type1, hiber1, id1}, {name2, type2, hiber2, id2}} do
      {first, second} when first > second -> :gt
      {first, second} when first < second -> :lt
      _ -> :eq
    end
  end
end
