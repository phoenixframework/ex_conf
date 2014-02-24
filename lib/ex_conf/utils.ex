defmodule ExConf.Utils do

  def capitalize(<<first, rest :: binary>>) do
    [first]
    |> String.from_char_list!
    |> String.upcase
    |> Kernel.<>(rest)
  end
end
