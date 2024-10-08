defmodule Kickplan.Requests.Metrics.Set do
  @moduledoc """
  TODO
  """

  @options NimbleOptions.new!(
             key: [
               type: :string,
               required: true
             ],
             value: [
               type: {:or, [:float, :integer]},
               required: false,
               default: 1.0
             ],
             account_key: [type: :string],
             idempotency_key: [type: :string],
             time: [type: :any]
           )

  @doc false
  def options, do: @options
end
