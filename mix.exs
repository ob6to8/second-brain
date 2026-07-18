defmodule ElixirMind.MixProject do
  use Mix.Project

  @moduledoc false

  def project do
    [
      app: :elixir_mind,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :crypto]
    ]
  end

  # No external dependencies: the contract compiler parses the small YAML
  # frontmatter subset the bundle uses with the standard library only, so it
  # runs offline in any sandbox with Elixir/OTP installed.
  defp deps, do: []

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
