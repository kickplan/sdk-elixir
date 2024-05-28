defmodule Kickplan.Adapter.Finch do
  @moduledoc """
  Built-in Finch-based Client for Kickplan.

      config :kickplan, :client, Kickplan.Client.Finch

  In order to use `Finch` API client, you must start `Finch` and provide a :name.
  Often in your supervision tree:

      children = [
        {Finch, name: Kickplan.Finch}
      ]

  Or, in rare cases, dynamically:

      Finch.start_link(name: Kickplan.Finch)

  If a name different from `Kickplan.Finch` is used, or you want to use an existing Finch instance,
  you can provide the name via the config.

      config :kickplan,
        client: {Kickplan.Client.Finch, name: My.Custom.Name},
  """

  require Logger

  @behaviour Kickplan.Adapter

  @impl true
  def init(_) do
    unless Code.ensure_loaded?(Finch) do
      Logger.error("""
      Could not find finch dependency.

      Please add :finch to your dependencies:

          {:finch, "~> 0.8"}

      Or set your own Kickplan.Client:

          config :kickplan, :client, MyClient
      """)

      raise "missing finch dependency"
    end

    _ = Application.ensure_all_started(:finch)
    :ok
  end

  @impl true
  def request(method, url, headers, body, opts) do
    {name, opts} = Keyword.pop(opts, :name, Kickplan.Finch)

    request = Finch.build(method, url, headers, body)

    case Finch.request(request, name, opts) do
      {:ok, response} ->
        {:ok, response.status, response.headers, response.body}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
