defmodule Kickplan.Config do
  @moduledoc """
  Utility to resolve app configurations.
  """

  @spec access_token() :: String.t()
  def access_token() do
    resolve(:access_token)
  end

  @spec adapter() :: {atom, Keyword.t()}
  def adapter() do
    resolve(:adapter) |> with_opts()
  end

  @spec base_url() :: URI.t()
  def base_url() do
    resolve(:base_url, "") |> URI.parse()
  end

  defp with_opts(mod) when is_atom(mod), do: {mod, []}
  defp with_opts({mod}), do: {mod, []}
  defp with_opts({_, _} = config), do: config

  @spec json_library() :: {atom, Keyword.t()}
  def json_library() do
    resolve(:json_library, Jason)
  end

  @spec user_agent() :: String.t()
  def user_agent() do
    resolve(:user_agent, "Kickplan/#{Kickplan.version()} (sdk-elixir)")
  end

  @spec resolve(atom, any) :: any
  def resolve(key, default \\ nil)

  def resolve(key, default) when is_atom(key) do
    Application.get_env(:kickplan, key, default) |> expand()
  end

  def resolve(key, _) do
    raise(
      ArgumentError,
      message: "#{__MODULE__} expected key '#{key}' to be an atom"
    )
  end

  defp expand({mod, fun, args}) when is_atom(fun) and is_list(args) do
    apply(mod, fun, args)
  end

  defp expand(value) when is_function(value), do: value.()
  defp expand(value), do: value
end
