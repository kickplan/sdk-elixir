defmodule Kickplan.Client do
  @moduledoc """
  TODO
  """

  alias Kickplan.{Config, Error, Request, Response}

  @doc false
  def init do
    {adapter, opts} = adapter()

    if Code.ensure_loaded?(adapter) and function_exported?(adapter, :init, 0) do
      :ok = adapter.init(opts)
    end

    :ok
  end

  @doc """
  TODO
  """
  def get(path, params \\ %{}, headers \\ []) do
    request(
      method: :get,
      path: path,
      params: params,
      headers: headers
    )
  end

  def post(path, body \\ %{}, headers \\ []) do
    request(
      method: :post,
      path: path,
      body: body,
      headers: headers
    )
  end

  @doc """
  TODO
  """
  def request(opts) when is_list(opts) do
    opts |> Request.build() |> request()
  end

  def request(%Request{prepared: false} = req) do
    req |> Request.prepare() |> request()
  end

  def request(%Request{} = req) do
    {adapter, opts} = adapter()

    case adapter.request(req.method, req.url, req.headers, req.body, opts) do
      {:ok, status, headers, body} when status in 200..299 ->
        {:ok, Response.build(req, status, headers, body)}

      {:ok, status, headers, body} ->
        {:error, Error.build(req, [status, headers, body])}

      {:error, reason} ->
        {:error, Error.build(req, reason)}
    end
  end

  defp adapter(), do: Config.adapter()
end
