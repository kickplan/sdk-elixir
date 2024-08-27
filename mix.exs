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
      {:credo, ">= 0.0.0", only: [:dev], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:doctor, ">= 0.0.0", only: [:dev], runtime: false},
      {:ex_check, "~> 0.14.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev], runtime: false},
      {:exvcr, "~> 0.11", only: :test},
      {:finch, "~> 0.6", optional: true},
      {:gettext, ">= 0.0.0", only: [:dev], runtime: false},
      {:hackney, "~> 1.9", optional: true},
      {:jason, "~> 1.0", optional: true},
      {:mix_audit, ">= 0.0.0", only: [:dev], runtime: false},
      {:nimble_options, "~> 1.1.0"},
      {:sobelow, ">= 0.0.0", only: [:dev], runtime: false}
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
