Code.ensure_loaded?(Hex) and Hex.start

defmodule ExConf.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_conf,
      version: "0.1.2",
      elixir: "~> 0.14.0",
      deps: deps,
      package: [
        contributors: ["Chris McCord"],
        licenses: ["MIT"],
        links: [github: "https://github.com/phoenixframework/ex_conf"]
      ],
      description: """
      Simple Elixir Configuration Management
      """
     ]
  end

  def application do
    []
  end

  defp deps do
    []
  end
end
