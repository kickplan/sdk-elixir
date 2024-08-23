defmodule Kickplan.Metrics do
  @moduledoc """
  TODO
  """

  alias Kickplan.{Client, Requests}

  @doc """
  TODO
  """
  def flush do
    with {:ok, resp} <- Client.post("metrics/flush") do
      {:ok, resp.success?}
    end
  end

  @doc """
  TODO
  """
  def set(opts \\ %{}) do
    with {:ok, params} <- validate(opts, Requests.Metrics.Set),
         {:ok, resp} <- Client.post("metrics/set", params) do
      {:ok, resp.success?}
    end
  end

  defp validate(opts, request) do
    NimbleOptions.validate(opts, request.options())
  end
end
