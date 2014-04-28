defmodule ExConf.Utils do

  def capitalize(<<first, rest :: binary>>) do
    [first]
    |> String.from_char_data!
    |> String.upcase
    |> Kernel.<>(rest)
  end
end
