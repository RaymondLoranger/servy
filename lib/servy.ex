defmodule Servy do
  @moduledoc """
  Servy keeps the contexts that define your domain
  and business logic.

  ```mermaid
      graph BT
      C(Client #3) ~~~ B(Client #2) ~~~ A(Client #1)
      A & B & C -->|request| GenServer
      GenServer -.->|reply| A & B & C
  ```

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
end
