defmodule Kickplan.MixProject do
  use Mix.Project

  @source_url "https://github.com/kickplan/sdk-elixir"
  @version "0.1.0"

  def project do
    [
      app: :kickplan,
      version: @version,
      elixir: "~> 1.15",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :runtime_tools],
      mod: {Kickplan.Application, []},
      env: [adapter: Kickplan.Adapter.Hackney]
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.0", optional: true},
      {:hackney, "~> 1.9", optional: true},
      {:finch, "~> 0.6", optional: true}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp package do
    [
      description: "An Elixir SDK for Kickplan",
      files: ["lib", "LICENSE*", "mix.exs", "README*"],
      licenses: ["MIT"],
      maintainers: ["Jared Hoyt"],
      links: %{
        "GitHub" => @source_url
      }
    ]
  end
end
