defmodule Kickplan.Error do
  @moduledoc """
  TODO
  """

  alias Kickplan.{Error, Request}

  @type source :: :adapter | :service

  @type code ::
          :bad_request
          | :unauthorized
          | :forbidden
          | :not_found
          | :server_error
          | :network_error
          | :unknown_error

  @type t :: %__MODULE__{
          code: code(),
          extra: %{atom() => term()},
          reason: String.t(),
          request: Request.t(),
          source: source()
        }

  defexception source: nil, code: nil, extra: %{}, request: nil, reason: nil

  @doc false
  def build(req, reason) when is_binary(reason) do
    %Error{
      source: :adapter,
      code: :network_error,
      reason: reason,
      request: req
    }
  end

  def build(req, [status, headers, body]) do
    {code, reason} = status_code_and_reason(status)

    %Error{
      source: :service,
      code: code,
      reason: reason,
      request: req,
      extra: %{status: status, headers: headers, body: body}
    }
  end

  defp status_code_and_reason(400) do
    {:bad_request, "The request was unacceptable, often due to missing a required parameter."}
  end

  defp status_code_and_reason(401) do
    {:unauthorized, "The required access token was missing or invalid."}
  end

  defp status_code_and_reason(403) do
    {:forbidden, "The access token provided does not have access to requested resource."}
  end

  defp status_code_and_reason(404) do
    {:not_found, "The requested resource could not be found."}
  end

  defp status_code_and_reason(status) when status in 500..599 do
    {:server_error, "A service error occurred on the Kickplan API."}
  end

  defp status_code_and_reason(status) do
    {:unknown_error, "An unknown HTTP code of #{status} was received."}
  end

  @doc false
  def message(%Error{request: %{url: url, method: method}, reason: reason}) do
    "#{inspect(reason)} (#{method |> to_string |> String.upcase()} #{to_string(url)})"
  end
end
