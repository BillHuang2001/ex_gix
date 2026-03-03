defmodule ExGix.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_gix,
      version: "0.1.2",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      package: package(),
      name: "ExGix",
      source_url: "https://github.com/BillHuang2001/ex_gix",
      docs: [
        main: "readme",
        extras: ["README.md"]
      ]
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
      {:rustler, "~> 0.37.0", optional: true},
      {:rustler_precompiled, "~> 0.8"},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false}
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
      },
      files: [
        "lib",
        "native/ex_gix/src",
        "native/ex_gix/Cargo.toml",
        "native/ex_gix/README.md",
        "checksum-Elixir.ExGix.Native.exs",
        "mix.exs",
        "README.md",
        "LICENSE"
      ]
    ]
  end
end
