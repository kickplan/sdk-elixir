defmodule Kickplan.Request do
  @moduledoc """
  TODO
  """
  alias Kickplan.{Config, Request}

  @type body :: iodata() | nil
  @type headers :: [{name :: String.t(), value :: String.t()}] | []
  @type method :: :get | :post | :put | :delete | :patch | :head | :options
  @type params :: map()
  @type path :: String.t()
  @type url :: URI.t() | nil

  @type t :: %__MODULE__{
          body: body(),
          headers: headers(),
          method: method(),
          params: params(),
          path: path(),
          prepared: boolean(),
          url: url()
        }

  @derive {Inspect, except: [:headers, :prepared]}
  defstruct body: nil,
            headers: [],
            method: nil,
            params: %{},
            path: nil,
            prepared: false,
            url: nil

  @methods [
    :get,
    :post,
    :put,
    :patch,
    :delete,
    :head,
    :options
  ]

  @doc """
  TODO
  """
  def build(opts \\ []) do
    body = Keyword.get(opts, :body)
    headers = Keyword.get(opts, :headers, [])
    method = Keyword.get(opts, :method, :get)
    params = Keyword.get(opts, :params, %{})
    path = Keyword.get(opts, :path, "")

    %Request{}
    |> put_body(body)
    |> put_headers(headers)
    |> put_method(method)
    |> put_params(params)
    |> put_path(path)
  end

  @doc """
  TODO
  """
  def prepare(%Request{prepared: false} = req) do
    req =
      req
      |> prepare_body()
      |> prepare_headers()
      |> prepare_url()

    %{req | prepared: true}
  end

  def prepare(%Request{} = req), do: req
  def prepare(opts) when is_list(opts), do: prepare(opts) |> prepare()

  defp prepare_body(%Request{body: nil} = req) do
    put_body(req, "")
  end

  defp prepare_body(%Request{body: body} = req) do
    put_body(req, Config.json_library().encode!(body))
  end

  defp prepare_headers(%Request{} = req) do
    defaults =
      [
        {"Authorization", "Bearer #{Config.access_token()}"},
        {"Content-Type", "application/json"},
        {"User-Agent", Config.user_agent()}
      ]

    put_headers(req, defaults)
  end

  defp prepare_url(%Request{} = req) do
    url =
      Config.base_url()
      |> URI.append_path(req.path)
      |> maybe_append_query(req.params)

    put_url(req, url)
  end

  defp maybe_append_query(url, params) when params == %{}, do: url

  defp maybe_append_query(url, params) do
    query = URI.encode_query(params)
    URI.append_query(url, query)
  end

  @doc """
  TODO
  """
  def put_body(%Request{} = req, body) when is_list(body) do
    put_body(req, Map.new(body))
  end

  def put_body(%Request{} = req, body) do
    %{req | body: body}
  end

  @doc """
  TODO
  """
  def put_headers(%Request{} = req, headers) when is_map(headers) do
    put_headers(req, Enum.into(headers, []))
  end

  def put_headers(%Request{} = req, headers) when is_list(headers) do
    %{req | headers: headers ++ req.headers}
  end

  def put_headers(%Request{}, _) do
    raise ArgumentError, "request headers must be an enumerable"
  end

  @doc """
  TODO
  """
  def put_header(%Request{} = req, key, value) do
    put_headers(req, [{key, value}])
  end

  @doc """
  TODO
  """
  def put_method(%Request{} = req, method) when method in @methods do
    %{req | method: method}
  end

  def put_method(_, method) do
    supported = Enum.map_join(@methods, ", ", &inspect/1)

    raise ArgumentError, """
    unknown request method #{inspect(method)}

    Method must be one of [#{supported}].
    """
  end

  @doc """
  TODO
  """
  def put_params(%Request{} = req, params) when is_list(params) do
    put_params(req, Map.new(params))
  end

  def put_params(%Request{} = req, params) when is_map(params) do
    %{req | params: Map.merge(req.params, params)}
  end

  def put_params(%Request{}, _) do
    raise ArgumentError, "request params must be an enumerable"
  end

  @doc """
  TODO
  """
  def put_param(%Request{} = req, key, value) do
    %{req | params: Map.put(req.params, key, value)}
  end

  @doc """
  TODO
  """
  def put_path(%Request{} = req, "/" <> _ = path) do
    %{req | path: path}
  end

  def put_path(%Request{} = req, path) when is_binary(path) do
    put_path(req, "/#{path}")
  end

  def put_path(%Request{}, _) do
    raise ArgumentError, "request path must be a string"
  end

  @doc """
  TODO
  """
  def put_url(%Request{}, %URI{scheme: nil}) do
    raise ArgumentError, "request url must be an absolute URI"
  end

  def put_url(%Request{} = req, url) when is_binary(url) do
    put_url(req, URI.parse(url))
  end

  def put_url(%Request{} = req, url) do
    %{req | url: url}
  end
end
