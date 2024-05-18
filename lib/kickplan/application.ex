defmodule Kickplan.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    Kickplan.Client.init()

    children = []
    opts = [strategy: :one_for_one, name: Kickplan.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
