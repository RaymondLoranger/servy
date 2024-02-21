defmodule Servy.Wildthings do
  use PersistConfig

  require Logger

  alias Servy.{Bear, Lion}

  @bears_json_path get_env(:bears_json_path)
  @lions_json_path get_env(:lions_json_path)
  @bears get_env(:bears)
  @lions get_env(:lions)
  @bears (case(File.read(@bears_json_path)) do
            {:ok, json} ->
              json
              |> Poison.decode!(as: %{"bears" => [%Bear{}]})
              |> Map.get("bears")

            {:error, _reason} ->
              # msg = "Error reading '#{@bears_json_path}'"
              # Logger.warning("#{msg}: #{:file.format_error(reason)}")
              @bears
          end)
  @lions (case(File.read(@lions_json_path)) do
            {:ok, json} ->
              json
              |> Poison.decode!(as: %{"lions" => [%Lion{}]})
              |> Map.get("lions")

            {:error, _reason} ->
              # msg = "Error reading '#{@lions_json_path}'"
              # Logger.warning("#{msg}: #{:file.format_error(reason)}")
              @lions
          end)

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
