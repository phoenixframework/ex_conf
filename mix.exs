defmodule ExConf.Mixfile do
  use Mix.Project

  def project do
    [ app: :ex_conf,
      version: "0.0.1",
      elixir: "~> 0.12.4 or ~> 0.13.0-dev",
      deps: deps ]
  end

  def application do
    []
  end

  defp deps do
    []
  end
end
