defmodule Servy.Lion do
  alias __MODULE__

  defstruct id: nil,
            name: "",
            type: ""

  @type t :: %Lion{
          id: non_neg_integer | nil,
          name: String.t(),
          type: String.t()
        }

  @spec is_white(t) :: boolean
  def is_white(lion), do: lion.type == "White"

  @spec order_asc_by_name(t, t) :: boolean
  def order_asc_by_name(l1, l2), do: l1.name <= l2.name

  @spec compare(t, t) :: :lt | :eq | :gt
  def compare(%Lion{} = lion1, %Lion{} = lion2) do
    %{name: name1, type: type1, id: id1} = lion1
    %{name: name2, type: type2, id: id2} = lion2

    case {{name1, type1, id1}, {name2, type2, id2}} do
      {first, second} when first > second -> :gt
      {first, second} when first < second -> :lt
      _ -> :eq
    end
  end
end
