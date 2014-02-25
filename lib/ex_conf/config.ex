defmodule ExConf.Config do
  alias ExConf.Utils

  defmacro __using__(opts) do
    unless Enum.empty? opts do
      env_var = Keyword.get(opts, :env_var) || raise ArgumentError, message: """
      Missing required :env_var option
      """
    end

    quote do
      Module.register_attribute __MODULE__, :config, accumulate: true,
                                                     persist: false
      @env_var unquote(env_var)
      @defaults []
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro defdefaults(default_configs) do
    config_ast(default_configs)
  end

  def config_ast(configs) do
    Enum.reduce configs, nil, fn {category, options}, acc ->
      quote do
        defconfig unquote(category), unquote(options)
        unquote(acc)
      end
    end
  end

  defmacro def__using__ do
    quote do
      defmacro __using__(_opts) do
        unevald_local_defaults = Macro.escape(@config)
        local_env_var = @env_var
        quote do
          use ExConf.Config, env_var: unquote(local_env_var)
          @defaults unquote(unevald_local_defaults)
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
        ExConf.Config.conf_module_for_env(@env_var, __MODULE__)
      end
      unquote(config_ast)
      defdefaults(unquote(defaults))
    end
  end

  defmacro defconfig(category, options) do
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
  name postfixed with the capitalized @env_var

  If no Env specific Config module is defined, the based Config module is
  returned
  """
  def conf_module_for_env(nil, base_module), do: base_module
  def conf_module_for_env(env_var, base_module) do
    env_module = Utils.capitalize(current_env_value(env_var))
    conf_mod = Module.concat(base_module, env_module)
    if Code.ensure_loaded? conf_mod do
      conf_mod
    else
      base_module
    end
  end

  defp current_env_value(env_var), do: System.get_env(env_var) || "dev"


  @doc """
  Merges config category options with default settings for the given module
  """
  def merge_with_defaults(category, options, module) do
    defaults = Module.get_attribute(module, :defaults)
    Dict.merge(Macro.expand(defaults[category], module) || [], options)
  end
end

