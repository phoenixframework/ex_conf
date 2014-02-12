defmodule ExConfTest do
  use ExUnit.Case

  defmodule BaseConfig do
    use ExConf.Config

    config :router, ssl: true, domain: "example.dev"
    config :session, secret: "secret"
  end

  defmodule ExtendedConfig do
    use BaseConfig

    config :router, ssl: false
    config :twitter, api_token: "ABC"
    config :code, reload: true
  end

  defmodule ExtendedExtendedConfig do
    use ExtendedConfig

    config :router, domain: "some.dev"
    config :twitter, api_token: "123"
  end

  test "base configuration assigns config categories with accessors" do
    assert BaseConfig.router[:ssl] == true
    assert BaseConfig.router[:domain] == "example.dev"
    assert BaseConfig.session[:secret] == "secret"
  end

  test "extending configuration merges defaults and includes all base configs" do
    assert ExtendedConfig.router[:ssl] == false
    assert ExtendedConfig.router[:domain] == "example.dev"
    assert ExtendedConfig.session[:secret] == "secret"
    assert ExtendedExtendedConfig.code[:reload] == true
  end

  test "extending configuration can include own additional configs" do
    assert ExtendedConfig.twitter[:api_token] == "ABC"
  end

  test "extending extended configuration merges defaults and includes all prior configs" do
    assert ExtendedExtendedConfig.router[:ssl] == false
    assert ExtendedExtendedConfig.router[:domain] == "some.dev"
    assert ExtendedExtendedConfig.twitter[:api_token] == "123"
    assert ExtendedExtendedConfig.code[:reload] == true
  end
end
