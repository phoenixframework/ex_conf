defmodule ExConf.Config do

  defmacro __using__(_opts) do
    quote do
      Module.register_attribute __MODULE__, :config, accumulate: true,
                                                     persist: false
      @defaults []
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro defdefaults(default_configs) do
    Enum.reduce default_configs, nil, fn {category, options}, acc ->
      quote do
        defconfig unquote(category), unquote(options), __MODULE__
        unquote(acc)
      end
    end
  end

  def config_ast(configs) do
    Enum.reduce configs, nil, fn {category, options}, acc ->
      quote do
        defconfig unquote(category), unquote(options), __MODULE__
        unquote(acc)
      end
    end
  end

  defmacro def__using__ do
    quote do
      defmacro __using__(_opts) do
        local_defaults = @config

        quote do
          use ExConf.Config
          @defaults unquote(local_defaults)
        end
      end
    end
  end

  defmacro __before_compile__(env) do
    config_ast = config_ast(Module.get_attribute env.module, :config)
    defaults = Module.get_attribute(env.module, :defaults)

    quote do
      def__using__
      def env do
        ExConf.Config.conf_module_for_env(Mix.env, __MODULE__)
      end
      unquote(config_ast)
      defdefaults(unquote(defaults))
    end
  end

  defmacro defconfig(category, options, module) do
    quote do
      unless Module.defines?(__MODULE__, {unquote(category), 0}) do
        def unquote(category)() do
          unquote(options)
        end
      end
    end
  end

  @doc """
  Creates a configuration category on the calling module, using defaults
  from the parent Configuration
  """
  defmacro config(category, options) when is_atom(category)
                                     when is_list(options) do

    unevald_opts = Macro.escape(options)
    quote bind_quoted: [category: category, unevald_opts: unevald_opts] do
      opts_with_defaults = merge_with_defaults(category, unevald_opts, __MODULE__)

      @config {category, opts_with_defaults}
    end
  end


  @doc """
  Finds the Config Module for the given environment from the base module
  name postfixed with the capitalized Mix.env

  If no Env specific Config module is defined, the based Config module is
  returned
  """
  def conf_module_for_env(env, base_module) do
    conf_mod = Module.concat(base_module, Inflex.capitalize(to_string(env)))
    if Code.ensure_loaded? conf_mod do
      conf_mod
    else
      base_module
    end
  end


  @doc """
  Merges config category options with default settings for the given module
  """
  def merge_with_defaults(category, options, module) do
    defaults = Module.get_attribute(module, :defaults)
    Dict.merge(Macro.expand(defaults[category], module) || [], options)
  end
end

