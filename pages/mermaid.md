# Mermaid diagram:
  ```mermaid
  graph BT
      C(Client #3) ~~~ B(Client #2) ~~~ A(Client #1)
      A & B & C -->|request| GenServer
      GenServer -.->|reply| A & B & C
  ```
