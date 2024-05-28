defmodule Kickplan.Adapter do
  @moduledoc """
  TODO
  """

  alias Kickplan.{Request, Response}

  @type options :: any()

  @doc """
  TODO
  """
  @callback init(options) :: :ok

  @doc """
  TODO
  """
  @callback request(Request.method(), Request.url(), Request.headers(), Request.body(), options) ::
              {:ok, Response.status(), Response.headers(), Response.body()} | {:error, term()}

  @optional_callbacks init: 1
end
