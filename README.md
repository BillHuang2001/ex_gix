# ExGix

[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgray.svg)](https://hexdocs.pm/ex_gix/)
[![GitHub](https://img.shields.io/badge/github-repo-black.svg?logo=github)](https://github.com/BillHuang2001/ex_gix)

This project provides high-level git operations through rustler bindings to the [gitoxide](https://github.com/GitoxideLabs/gitoxide) library, which is a pure Rust implementation of Git. The goal of this project is to provide a high-performance, native Git library for Elixir applications.

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

## Usage Guide

ExGix provides a high-level API for interacting with Git repositories. Here are some examples of what you can do:

### Opening and Initializing Repositories

```elixir
# Open an existing repository
{:ok, repo} = ExGix.open(".")

# Or discover a repository from a subdirectory
{:ok, repo} = ExGix.discover("test/some/nested/dir")

# Initialize a new repository
{:ok, repo} = ExGix.init("/path/to/new/repo")

# Get repository properties
ExGix.is_bare(repo) #=> false
ExGix.path(repo) #=> "/path/to/repo/.git"
{:ok, head_name} = ExGix.head_name(repo) #=> {:ok, "refs/heads/main"}
```

### Reading Files and Objects

You can read the contents of files from the repository without needing a working tree:

```elixir
{:ok, repo} = ExGix.open(".")

# Read a file directly from HEAD
{:ok, content} = ExGix.cat_file(repo, "HEAD:README.md")

# Resolve references to object IDs
{:ok, commit_id} = ExGix.rev_parse(repo, "HEAD")
{:ok, blob_id} = ExGix.rev_parse(repo, "HEAD:README.md")

# Read using an object ID
{:ok, content} = ExGix.cat_file(repo, blob_id)
```

Working with Object IDs (`ExGix.ObjectId`):

```elixir
# Parse from hex
{:ok, oid} = ExGix.ObjectId.from_hex("e69de29bb2d1d6434b8b29ae775ad8c2e48c5391")

# Convert to hex
hex_string = ExGix.ObjectId.to_hex(oid)

# Check object properties
ExGix.ObjectId.is_empty_tree(oid)
ExGix.ObjectId.is_empty_blob(oid)
```

### Checking Repository Status

You can check the status of files in the working directory compared to the index and HEAD:

```elixir
{:ok, repo} = ExGix.Repository.open(".")
{:ok, status_items} = ExGix.Repository.status(repo)

# Example output item:
# %ExGix.StatusItem{
#   location: :index_worktree, # or :tree_index
#   path: "lib/ex_gix.ex",
#   status: :modified          # :modified, :untracked, :added, etc.
# }
```

### Listing Tree Contents

You can list the contents of a tree (directory) at a specific revision:

```elixir
{:ok, repo} = ExGix.Repository.open(".")

# List root directory of HEAD
{:ok, items} = ExGix.Repository.ls_tree(repo, "HEAD")

# List a specific subdirectory
{:ok, items} = ExGix.Repository.ls_tree(repo, "HEAD:lib")

# List recursively
{:ok, items} = ExGix.Repository.ls_tree(repo, "HEAD", recursive: true)

# Example output item:
# %ExGix.TreeItem{
#   filename: "README.md",
#   kind: :blob,       # :blob, :tree, :exe, etc.
#   mode: "100644",
#   oid: <reference>   # Object reference
# }
```

### Committing Changes

You can create new commits programmatically:

```elixir
{:ok, repo} = ExGix.Repository.open(".")

# Define the author/committer signature
sig = %ExGix.Signature{
  name: "Committer Name",
  email: "committer@example.com",
  time_seconds: System.os_time(:second),
  time_offset: 0
}

# Commit changes (uses the current index/staged changes)
{:ok, commit_id} = ExGix.Repository.commit_as(
  repo,
  sig,                   # Author
  sig,                   # Committer
  "Test commit message"  # Message
)
```

## Why ExGix?

The Elixir ecosystem has historically relied on wrappers around the C library `libgit2` (such as `egit`) or pure Elixir implementations like `xgit`. While valuable, these approaches have limitations—C bindings can introduce memory safety risks, and pure Elixir implementations may struggle with the performance required for large repositories.

ExGix bridges this gap by leveraging [gitoxide](https://github.com/GitoxideLabs/gitoxide), a high-performance pure Rust implementation of Git.

- **Performance:** ExGix provides the speed of native code, supporting multi-process access and efficient object handling.
- **Safety:** Built on Rust's memory-safe guarantees, ExGix avoids the common pitfalls of C interoperability, ensuring that NIF execution does not compromise the stability of the BEAM VM.
- **Idiomatic Ergonomics:** Unlike bindings that might crash on errors or return raw values, ExGix adheres to Elixir conventions. Expect `{:ok, repo}` and `{:error, reason}` tuples, making it easy to compose pipelines and handle failures gracefully.
- **Extensibility:** By building on the modular `gitoxide` library, ExGix benefits from a modern, actively developed foundation, enabling easier access to lower-level Git internals and advanced features.

## Architecture & Design

Opening a Git repository in ExGix creates a `RepoResource` that contains a `gix::ThreadSafeRepository`. This `ThreadSafeRepository` is a lightweight, thread-safe wrapper around the underlying Git repository data structures.
In every native function call, ExGix creates a lightweight, thread-local `Repository` instance from the shared `ThreadSafeRepository` using `.to_thread_local()`, ensuring that operations run concurrently without bottlenecking the Erlang schedulers.

## Local Development

If you want to contribute to `ex_gix` or build the Rust NIF locally instead of using precompiled binaries, you need to set the `EX_GIX_BUILD` environment variable to `1`:

```bash
export EX_GIX_BUILD=1
mix deps.get
mix compile
mix test
```
