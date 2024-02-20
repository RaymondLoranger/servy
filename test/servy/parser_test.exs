defmodule Servy.ParserTest do
  use ExUnit.Case, async: true

  alias Servy.{Conv, Parser}

  doctest Parser

  setup_all do
    requests = [
      """
      GET /wildthings HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      \r
      """,
      """
      POST /bears HTTP/1.1\r
      Host: example.com\r
      User-Agent: ExampleBrowser/1.0\r
      Accept: */*\r
      Content-Type: application/x-www-form-urlencoded\r
      Content-Length: 21\r
      \r
      name=Baloo&type=Brown
      """
    ]

    {:ok, requests: requests}
  end

  describe "Parser.parse/1" do
    test "parses a request into a conv struct", %{requests: requests} do
      assert requests |> Enum.at(0) |> Parser.parse() == %Conv{
               method: "GET",
               path: "/wildthings",
               params: %{}
             }

      assert requests |> Enum.at(1) |> Parser.parse() == %Conv{
               method: "POST",
               path: "/bears",
               params: %{"name" => "Baloo", "type" => "Brown"}
             }
    end
  end
end
