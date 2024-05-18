defmodule Kickplan.Response do
  @moduledoc """
  TODO
  """

  alias Kickplan.{Config, Request, Response}

  @type body :: any()
  @type headers :: [{name :: String.t(), value :: String.t()}]
  @type status :: pos_integer()

  @type t :: %__MODULE__{
          body: body(),
          headers: headers(),
          request: Request.t() | nil,
          status: status(),
          success?: boolean()
        }

  defstruct body: nil,
            headers: [],
            request: nil,
            status: nil,
            success?: false

  @doc """
  TODO
  """
  def build(%Request{} = req \\ nil, status, headers, body) do
    %Response{headers: headers, request: req}
    |> process_body(body)
    |> process_status(status)
  end

  defp process_body(%Response{} = resp, body) do
    body =
      case Config.json_library().decode(body) do
        {:ok, decoded_body} -> decoded_body
        {:error, _} -> body
      end

    %{resp | body: body}
  end

  defp process_status(%Response{} = resp, status) when status in 200..299 do
    %{resp | status: status, success?: true}
  end

  defp process_status(%Response{} = resp, status) do
    %{resp | status: status}
  end

  @doc """
  TODO
  """
  def into(%Response{} = resp, schema) do
    cast_into(resp.body, schema)
  end

  defp cast_into([head | tail], schema) do
    [cast_into(head, schema) | cast_into(tail, schema)]
  end

  defp cast_into([], _), do: []
  defp cast_into(data, schema), do: schema.from_json(data)
end
