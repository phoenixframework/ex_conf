# ExConf
> Simple Elixir Configuration Management



## Features
- Configuration definitions are *evaluated at runtime*, but merged/defaulted at compile time, allowing runtime dependent lookups. (i.e. `System.get_env`)
- Configuration modules can extend other configurations for overrides and defaults
- Evironment based lookup for settings based on provided `env_var`

## Simple Example
```elixir

defmodule MyApp.Config do
  use ExConf.Config

  config :router, ssl: true,
                  domain: "example.dev",
                  port: System.get_env("PORT")

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

First, establish a *base* configuration module that uses `ExConf.Config` and
provide an `env_var` option for `System.get_env` lookup at runtime of the current
application environment.
```elixir
defmodule MyApp.Config do
  use ExConf.Config, env_var: "MIX_ENV"

  config :router, ssl: true
  config :twitter, api_token: System.get_env("API_TOKEN")
end
```

Next, define "submodules" for each environment you need overrides or additional settings for.
The *base* config module will look for a "submodule" whos name is the value of
`:env_var` fetched from `System.get_env` in capitalized form.
This allows environment specific lookup at runtime via the `env/0` function on the base module.
If the environment specific config module does not exist, it falls back to the base module.

Here's what a Dev enviroment config module would look like for `System.get_env("MIX_ENV") == "dev"`:
```elixir
defmodule MyApp.Config.Dev do
  use MyApp.Config

  config :router, ssl: false
  config :twitter, api_token: "ABC"
end

iex> System.get_env("MIX_ENV")
"dev"

iex> MyApp.Config.env
MyApp.Config.Dev

iex> MyApp.Config.env.router[:ssl]
false
```

