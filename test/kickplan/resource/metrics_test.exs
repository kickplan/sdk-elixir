defmodule Kickplan.MetricsTest do
  use Kickplan.VCRCase, async: true

  alias Kickplan.Metrics

  describe "flush/0" do
    test "success: flushes the metrics" do
      use_cassette "metrics/flush" do
        assert {:ok, true} = Metrics.flush()
      end
    end
  end

  describe "set/1" do
    test "success: resolves a single feature" do
      use_cassette "metrics/set", match_requests_on: [:request_body] do
        assert {:ok, true} =
                 Metrics.set(
                   key: "sdk_elixir_test",
                   account_key: "9a592f57-6da0-408e-99e7-8918b48a7dbe"
                 )

        assert {:ok, true} =
                 Metrics.set(
                   key: "sdk_elixir_test",
                   value: 3,
                   account_key: "9a592f57-6da0-408e-99e7-8918b48a7dbe",
                   idempotency_key: "004b7f07-71fd-4ea5-a43c-dcde2516305b"
                 )
      end
    end

    test "error: request has invalid params" do
      assert {:error, %NimbleOptions.ValidationError{}} =
               Metrics.set(value: 1)
    end
  end
end
