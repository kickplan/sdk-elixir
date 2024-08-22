defmodule Kickplan.FeaturesTest do
  use Kickplan.VCRCase, async: true

  alias Kickplan.Features
  alias Kickplan.Schema.Resolution

  describe "resolve/2" do
    test "success: resolves all features" do
      use_cassette "features/resolve-all" do
        {:ok, resolutions} = Features.resolve()

        assert length(resolutions) == 5

        assert Enum.all?(resolutions, fn resolution ->
                 %Resolution{} = resolution
               end)
      end
    end

    test "success: resolves a single feature" do
      use_cassette "features/resolve" do
        {:ok, resolution} = Features.resolve("contact-limit")

        assert %Resolution{key: "contact-limit"} = resolution
      end
    end
  end
end
