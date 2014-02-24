defmodule ExConf.Mixfile do
  use Mix.Project

  def project do
    [ app: :ex_conf,
      version: "0.0.1",
      elixir: "~> 0.12.4",
      deps: deps ]
  end

  def application do
    [mod: { ExConf, [] }]
  end

  defp deps do
    []
  end
end
