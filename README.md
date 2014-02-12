# ExConf
> Simple Elixir Configuration Management

## Simple Example with configuration extension

```elixir

defmodule MyApp.Config do
  use ExConf.Config

  config :router, ssl: true, domain: "example.dev"
  config :session, secret: "secret"
end

iex> MyApp.Config.router[:domain]
"example.dev"


defmodule MyApp.OtherConfig do
  use MyApp.Config

  config :session, secret: "123password"
end

iex> MyApp.OtherConfig.session[:secret]
"123password"
iex> MyApp.OtherConfig.router[:ssl]
true
```


## Environment Based Configuration
The *base* config module will look for a submodule with Mix.env capitalized
as its name to know what configuratio module to lookup at runtime. If
the Mix.env specific config module does not exist, it falls back to base module.

```elixir

defmodule MyApp.Config do
  use ExConf.Config

  config :router, ssl: true, domain: "example.dev"
  config :session, secret: "secret"
end

defmodule MyApp.Config.Dev do
  use MyApp.Config

  config :router, ssl: false
  config :twitter, api_token: "ABC"
  config :code, reload: true
end

iex> Mix.env
:dev

iex> MyApp.Config.env
MyApp.Config.Dev

iex> MyApp.Config.env.router[:ssl]
false
```

