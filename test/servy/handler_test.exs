defmodule Servy.MyHandlerTest do
  use ExUnit.Case, async: true

  alias Servy.Handler

  doctest Handler

  setup_all do
    keywords = [
      [
        request: """
        GET /wildthings HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 76\r
        \r
        🎉🎉🎉🎉🎉
        <div>
        Bears, Lions, Tigers
        </div>

        🎉🎉🎉🎉🎉
        """
      ],
      [
        request: """
        GET /wildlife HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 76\r
        \r
        🎉🎉🎉🎉🎉
        <div>
        Bears, Lions, Tigers
        </div>

        🎉🎉🎉🎉🎉
        """
      ],
      [
        request: """
        GET /bears HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 413\r
        \r
        🎉🎉🎉🎉🎉
        <h1>All the Bears! (10)</h1>

        <ul>
        \s\s
            <li>Brutus - Grizzly</li>
        \s\s
            <li>Iceman - Polar</li>
        \s\s
            <li>Kenai - Grizzly</li>
        \s\s
            <li>Paddington - Brown</li>
        \s\s
            <li>Roscoe - Panda</li>
        \s\s
            <li>Rosie - Black</li>
        \s\s
            <li>Scarface - Grizzly</li>
        \s\s
            <li>Smokey 🐻 - Black</li>
        \s\s
            <li>Snow - Polar</li>
        \s\s
            <li>Teddy 🧸 - Brown</li>
        \s\s
        </ul>

        🎉🎉🎉🎉🎉
        """
      ],
      [
        request: """
        GET /lions HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 236\r
        \r
        🎉🎉🎉🎉🎉
        <h1>All the Lions!</h1>

        <ul>
        \s\s
            <li>Elsa - Cub</li>
        \s\s
            <li>Kimba - White</li>
        \s\s
            <li>Lambert - Sheepish</li>
        \s\s
            <li>Mufasa - King</li>
        \s\s
            <li>Simba 🦁 - Cub</li>
        \s\s
        </ul>

        🎉🎉🎉🎉🎉
        """
      ],
      [
        request: """
        GET /bears/1 HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 169\r
        \r
        🎉🎉🎉🎉🎉
        <h1>Show Bear</h1>

        <p>
          Is Teddy 🧸 hibernating? <strong>true</strong>
          <br>
          Is Teddy 🧸 a grizzly? <b>false</b>
        </p>

        🎉🎉🎉🎉🎉
        """
      ],
      [
        request: """
        GET /lions/2 HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 114\r
        \r
        🎉🎉🎉🎉🎉
        <h1>Show Lion</h1>

        <p>
          Is Simba 🦁 a white lion? <b>false</b>
        </p>

        🎉🎉🎉🎉🎉
        """
      ],
      [
        request: """
        GET /bears?id=1 HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 169\r
        \r
        🎉🎉🎉🎉🎉
        <h1>Show Bear</h1>

        <p>
          Is Teddy 🧸 hibernating? <strong>true</strong>
          <br>
          Is Teddy 🧸 a grizzly? <b>false</b>
        </p>

        🎉🎉🎉🎉🎉
        """
      ],
      [
        request: """
        GET /lions?id=2 HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 114\r
        \r
        🎉🎉🎉🎉🎉
        <h1>Show Lion</h1>

        <p>
          Is Simba 🦁 a white lion? <b>false</b>
        </p>

        🎉🎉🎉🎉🎉
        """
      ],
      [
        request: """
        DELETE /bears/1 HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 403 Forbidden\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 29\r
        \r
        Deleting a bear is forbidden!
        """
      ],
      [
        request: """
        DELETE /lions/1 HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 403 Forbidden\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 29\r
        \r
        Deleting a lion is forbidden!
        """
      ],
      [
        request: """
        GET /about HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 372\r
        \r
        🎉🎉🎉🎉🎉
        <h1>Clark's Wildthings Refuge</h1>

        <blockquote>
          When we contemplate the whole globe as one great dewdrop,
          striped and dotted with continents and islands, flying through
          space with other stars all singing and shining together as one,
          the whole universe appears as an infinite storm of beauty.
          -- John Muir
        </blockquote>

        🎉🎉🎉🎉🎉
        """
      ],
      [
        request: """
        POST /bears HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        Content-Type: application/x-www-form-urlencoded\r
        Content-Length: 21\r
        \r
        name=Baloo&type=Brown
        """,
        response: """
        HTTP/1.1 201 Created\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 33\r
        \r
        Created a Brown bear named Baloo!
        """
      ],
      [
        request: """
        POST /lions HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        Content-Type: application/x-www-form-urlencoded\r
        Content-Length: 21\r
        \r
        name=Leo&type=Majestic
        """,
        response: """
        HTTP/1.1 201 Created\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 34\r
        \r
        Created a Majestic lion named Leo!
        """
      ],
      [
        request: """
        POST /lions HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        Content-Type: application/x-www-form-urlencoded\r
        Content-Length: 21\r
        \r
        name=Leo&type=Iconic
        """,
        response: """
        HTTP/1.1 201 Created\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 33\r
        \r
        Created an Iconic lion named Leo!
        """
      ],
      [
        request: """
        POST /pledges HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        Content-Type: application/x-www-form-urlencoded\r
        Content-Length: 21\r
        \r
        name=José%20💰&amount=160.25
        """,
        response: """
        HTTP/1.1 201 Created\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 40\r
        \r
        <div>
        José 💰 pledged 160.25!
        </div>

        """
      ],
      [
        request: """
        GET /bigfoot HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 404 Not Found\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 17\r
        \r
        No /bigfoot here!
        """
      ],
      [
        request: """
        GET /api/bears HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: application/json; charset=utf-8\r
        Content-Length: 615\r
        \r
        [{"hibernating":true,"type":"Brown","name":"Teddy 🧸","id":1},{"hibernating":false,"type":"Black","name":"Smokey 🐻","id":2},{"hibernating":false,"type":"Brown","name":"Paddington","id":3},{"hibernating":true,"type":"Grizzly","name":"Scarface","id":4},{"hibernating":false,"type":"Polar","name":"Snow","id":5},{"hibernating":false,"type":"Grizzly","name":"Brutus","id":6},{"hibernating":true,"type":"Black","name":"Rosie","id":7},{"hibernating":false,"type":"Panda","name":"Roscoe","id":8},{"hibernating":true,"type":"Polar","name":"Iceman","id":9},{"hibernating":false,"type":"Grizzly","name":"Kenai","id":10}]
        """
      ],
      [
        request: """
        GET /api/lions HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        \r
        """,
        response: """
        HTTP/1.1 200 OK\r
        Content-Type: application/json; charset=utf-8\r
        Content-Length: 201\r
        \r
        [{"type":"King","name":"Mufasa","id":1},{"type":"Cub","name":"Simba 🦁","id":2},{"type":"White","name":"Kimba","id":3},{"type":"Sheepish","name":"Lambert","id":4},{"type":"Cub","name":"Elsa","id":5}]
        """
      ],
      [
        request: """
        POST /api/bears HTTP/1.1\r
        Host: example.com\r
        User-Agent: ExampleBrowser/1.0\r
        Accept: */*\r
        Content-Type: application/json\r
        Content-Length: 21\r
        \r
        {"name": "Breezly", "type": "Polar"}
        """,
        response: """
        HTTP/1.1 201 Created\r
        Content-Type: text/html; charset=utf-8\r
        Content-Length: 35\r
        \r
        Created a Polar bear named Breezly!
        """
      ]
    ]

    {:ok, keywords: keywords}
  end

  describe "Handler.handle/1" do
    test "returns proper response for given request", %{keywords: keywords} do
      Enum.each(keywords, fn [request: request, response: response] ->
        # assert request |> Handler.handle() |> remove_whitespace() ==
        #          remove_whitespace(response)
        assert Handler.handle(request) == response
      end)
    end
  end

  ## Private functions

  # defp remove_whitespace(text), do: String.replace(text, "\s", "")
  # Contrarily to "\s", ~r{\s} includes all whitespaces: [ \t\r\n\f].
  # defp remove_whitespace(text), do: String.replace(text, ~r{\s}, "")
end
