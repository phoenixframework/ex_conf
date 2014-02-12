defmodule EnvConfTest do
  use ExUnit.Case

  defmodule MyApp.Config do
    use ExConf.Config

    config :router, ssl: true, domain: "example.dev"
    config :session, secret: "secret"
  end

  defmodule MyApp.Config.Test do
    use MyApp.Config

    config :router, ssl: false
    config :twitter, api_token: "ABC"
    config :code, reload: true
  end

  defmodule MyOtherApp.Config do
    use ExConf.Config

    config :router, ssl: true, domain: "other.dev"
  end

  test "env/0 returns Config module based on Mix.env capitalized name" do
    assert MyApp.Config.env == MyApp.Config.Test
  end

  test "env/0 returns base Config module if no env Config module is defined for Mix.env" do
    assert MyOtherApp.Config.env == MyOtherApp.Config
    assert MyOtherApp.Config.env.router[:domain] == "other.dev"
  end


  test "test env configuration merges defaults and includes all base configs" do
    assert MyApp.Config.env.router[:ssl] == false
    assert MyApp.Config.env.router[:domain] == "example.dev"
    assert MyApp.Config.env.session[:secret] == "secret"
  end
end
