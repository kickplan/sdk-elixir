defmodule Kickplan.Schema.Resolution do
  @moduledoc """
  TODO
  """

  use Kickplan.Schema

  @type key :: String.t()
  @type value :: boolean() | String.t() | number() | map()
  @type error_message :: String.t()
  @type reason :: String.t()

  @type error_code ::
          :provide_not_ready
          | :flag_not_found
          | :parse_error
          | :type_mismatch
          | :targeting_key_missing
          | :invalid_context
          | :provider_fatal
          | :general

  @type t :: %__MODULE__{
          key: key(),
          value: value(),
          error_code: error_code() | nil,
          error_message: error_message() | nil,
          reason: nil,
          variant: nil,
          metadata: %{}
        }

  defstruct key: nil,
            value: nil,
            error_code: nil,
            error_message: nil,
            reason: nil,
            variant: nil,
            metadata: %{}
end
