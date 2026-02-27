# ExGix

This project provides rustler bindings to the [gitoxide](https://github.com/GitoxideLabs/gitoxide) library, which is a pure Rust implementation of Git. The goal of this project is to provide a high-performance, native Git library for Elixir applications.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_gix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_gix, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/ex_gix>.

## Why ExGix?

Previous, the popular choice for Git bindings in Elixir was [egit](https://github.com/saleyn/egit), which is a wrapper around the C library libgit2. However it has several limitations compared to a native Rust implementation:
- Performance: ExGix is designed to be fast, efficient and support multithreading access.
- Safety: ExGix's API is safer and closer to idiomatic Elixir, reducing the likelihood of bugs and memory safety issues that can arise with C bindings.
