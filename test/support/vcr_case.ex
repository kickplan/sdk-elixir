defmodule Kickplan.VCRCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
    end
  end

  setup do
    ExVCR.Config.cassette_library_dir("test/cassettes")
    ExVCR.Config.filter_request_headers("Authorization")

    :ok
  end
end
