defmodule Servy.BearView do
  use PersistConfig

  import EEx, only: [function_from_file: 4]

  @dir get_env(:bears_templates_path)

  function_from_file :def, :index, Path.join(@dir, "index.eex"), [:assigns]
  function_from_file :def, :show, Path.join(@dir, "show.eex"), [:assigns]
  defdelegate is_grizzly(bear), to: Servy.Bear
end
