defmodule ExGix.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_gix,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:rustler, "~> 0.37.0"}
    ]
  end

  defp aliases do
    [
      fmt: [
        "format",
        "cmd cargo fmt --manifest-path native/ex_gix/Cargo.toml"
      ]
    ]
  end

  defp package do
    [
      description: "A Git library for Elixir, powered by Gitoxide.",
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/BillHuang2001/ex_gix"
      }
    ]
  end
end
