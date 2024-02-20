defmodule Servy.Wildthings do
  use PersistConfig

  alias Servy.{Bear, Lion}

  @bears get_env(:bears)
  @lions get_env(:lions)

  @spec list_bears :: [Bear.t()]
  def list_bears, do: @bears

  @spec get_bear(integer | binary) :: Bear.t() | nil
  def get_bear(id) when is_integer(id),
    do: Enum.find(@bears, &(&1.id == id))

  def get_bear(id) when is_binary(id),
    do: id |> String.to_integer() |> get_bear()

  @spec list_lions :: [Lion.t()]
  def list_lions, do: @lions

  @spec get_lion(integer | binary) :: Lion.t() | nil
  def get_lion(id) when is_integer(id),
    do: Enum.find(@lions, &(&1.id == id))

  def get_lion(id) when is_binary(id),
    do: id |> String.to_integer() |> get_lion()
end
