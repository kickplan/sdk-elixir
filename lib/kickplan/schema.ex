defmodule Kickplan.Schema do
  @moduledoc """
  TODO
  """

  alias Kickplan.Schema

  defmacro __using__(_opts) do
    quote do
      def from_json(data) do
        Schema.cast_from_json(__MODULE__, data)
      end

      defoverridable from_json: 1
    end
  end

  @doc """
  TODO
  """
  def cast_from_json(kind, data) when is_map(data) do
    struct = struct(kind)
    fields = Map.keys(struct)

    Enum.reduce(fields, struct, fn field, acc ->
      case Map.fetch(data, Atom.to_string(field)) do
        {:ok, value} -> %{acc | field => value}
        :error -> acc
      end
    end)
  end

  def cast_from_json(kind, _), do: struct(kind)
end
