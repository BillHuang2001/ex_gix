defmodule ExGix do
  @moduledoc """
  ExGix provides a native Rust implementation of Git for Elixir applications.
  """

  alias ExGix.Repository

  @doc """
  Opens a Git repository at the given path, possibly expanding it to `path/.git` if `path` is a work tree dir.

  ## Examples

      iex> {:ok, repo} = ExGix.open(".")
      iex> is_reference(repo)
      true

  """
  defdelegate open(path), to: Repository

  @doc """
  Create a repository with work-tree within `directory`, creating intermediate directories as needed.
  """
  defdelegate init(directory), to: Repository

  @doc """
  Try to open a git repository in `directory` and search upwards through its parents until one is found.
  """
  defdelegate discover(directory), to: Repository

  @doc """
  Try to open a git repository directly from the environment. If that fails, discover upwards from `directory` until one is found, while applying discovery options from the environment.
  """
  defdelegate discover_with_environment_overrides(directory), to: Repository

  @doc """
  The path to the `.git` directory itself, or equivalent if this is a bare repository.
  """
  defdelegate path(repo), to: Repository

  @doc """
  Return the path to the repository itself, containing objects, references, configuration, and more.
  Synonymous to `path/1`.
  """
  defdelegate git_dir(repo), to: Repository

  @doc """
  Return the path to the working directory if this is not a bare repository.
  """
  defdelegate work_dir(repo), to: Repository

  @doc """
  Return the path to the directory containing all objects.
  """
  defdelegate objects_dir(repo), to: Repository

  @doc """
  Return true if this repository is bare.
  """
  defdelegate is_bare(repo), to: Repository

  @doc """
  Return true if the repository is a shallow clone.
  """
  defdelegate is_shallow(repo), to: Repository

  @doc """
  Resolve the HEAD reference and obtain its object id.
  """
  defdelegate head_id(repo), to: Repository

  @doc """
  Return the name to the symbolic reference HEAD points to, or nil if the head is detached.
  """
  defdelegate head_name(repo), to: Repository

  @doc """
  Return a set of unique short branch names.
  """
  defdelegate branch_names(repo), to: Repository

  @doc """
  Returns a sorted list unique of symbolic names of remotes.
  """
  defdelegate remote_names(repo), to: Repository

  @doc """
  Output the content of a blob object.
  """
  defdelegate cat_file(repo, revspec), to: Repository
end
