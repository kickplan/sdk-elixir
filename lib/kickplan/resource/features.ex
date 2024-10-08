defmodule Kickplan.Features do
  @moduledoc """
  TODO
  """

  alias Kickplan.{Client, Response, Schema}

  @doc """
  TODO
  """
  def resolve(key \\ nil, params \\ [])
  def resolve(key, _) when is_list(key) or is_map(key), do: resolve(nil, key)

  def resolve(key, params) do
    path =
      ["features", key, "resolve"]
      |> Enum.reject(&is_nil/1)
      |> Enum.join("/")

    with {:ok, resp} <- Client.post(path, params) do
      {:ok, resp |> Response.into(Schema.Resolution)}
    end
  end

  @doc """
  TODO
  """
  def resolve!(key \\ nil, params \\ []) do
    case resolve(key, params) do
      {:ok, response} -> response
      {:error, error} -> raise error
    end
  end
end
