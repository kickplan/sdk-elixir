defmodule Kickplan.ConfigTest do
  use ExUnit.Case, async: false

  alias Kickplan.Config

  defmodule MFATestModule do
    def value, do: "mfa-value"
  end

  describe "resolve/2" do
    test "success: returns the requested config value" do
      Application.put_env(:kickplan, :__test, "config-value")
      assert Config.resolve(:__test) == "config-value"
    end

    test "success: evaluates functional config values" do
      Application.put_env(:kickplan, :__test, fn -> "function-value" end)
      assert Config.resolve(:__test) == "function-value"
    end

    test "success: applies mfa config values" do
      Application.put_env(:kickplan, :__test, {MFATestModule, :value, []})

      assert Config.resolve(:__test) == "mfa-value"
    end

    test "success: uses default values for missing configs" do
      assert Config.resolve(:__fake_test, "default-value") == "default-value"
    end

    test "error: raises if the key isn't an atom" do
      assert_raise ArgumentError, ~r/to be an atom/, fn ->
        Config.resolve("__test")
      end
    end
  end
end
