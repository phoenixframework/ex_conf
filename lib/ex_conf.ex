defmodule ExConf do
  use Application.Behaviour

  def start(_type, _args) do
    ExConf.Supervisor.start_link
  end
end
