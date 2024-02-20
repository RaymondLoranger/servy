defmodule Servy.LionView do
  use PersistConfig

  import EEx, only: [function_from_file: 4]

  @dir get_env(:lions_templates_path)

  function_from_file :def, :index, Path.join(@dir, "index.eex"), [:assigns]
  function_from_file :def, :show, Path.join(@dir, "show.eex"), [:assigns]
  defdelegate is_white(lion), to: Servy.Lion
end
