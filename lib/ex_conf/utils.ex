defmodule ExConf.Utils do

  def capitalize(<<first, rest :: binary>>) do
    [first]
    |> to_string
    |> String.upcase
    |> Kernel.<>(rest)
  end
end
