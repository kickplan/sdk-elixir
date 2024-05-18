defmodule Kickplan.Adapter.Hackney do
  @moduledoc """
  Built-in hackney-based Client.
  """

  require Logger

  @behaviour Kickplan.Adapter

  @impl true
  def init(_) do
    unless Code.ensure_loaded?(:hackney) do
      Logger.error("""
      Could not find hackney dependency.

      Please add :hackney to your dependencies:

          {:hackney, "~> 1.9"}

      Or set your own Kickplan.Client:

          config :kickplan, :client, MyClient
      """)

      raise "missing hackney dependency"
    end

    _ = Application.ensure_all_started(:hackney)
    :ok
  end

  @impl true
  def request(method, url, headers, body, opts) do
    :hackney.request(
      method,
      to_string(url),
      headers,
      body,
      [:with_body | opts]
    )
  end
end
