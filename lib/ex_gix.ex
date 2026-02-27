defmodule ExGix do
  @moduledoc """
  ExGix provides a native Rust implementation of Git for Elixir applications.
  """

  @doc """
  Opens a Git repository at the given path, possibly expanding it to `path/.git` if `path` is a work tree dir.

  ## Examples

      iex> {:ok, repo} = ExGix.open(".")
      iex> is_reference(repo)
      true

  """
  @spec open(String.t()) :: {:ok, reference()} | {:error, String.t()}
  def open(path) when is_binary(path) do
    ExGix.Native.open(path)
  end

  @doc """
  Create a repository with work-tree within `directory`, creating intermediate directories as needed.
  """
  @spec init(String.t()) :: {:ok, reference()} | {:error, String.t()}
  def init(directory) when is_binary(directory) do
    ExGix.Native.init(directory)
  end

  @doc """
  Try to open a git repository in `directory` and search upwards through its parents until one is found.
  """
  @spec discover(String.t()) :: {:ok, reference()} | {:error, String.t()}
  def discover(directory) when is_binary(directory) do
    ExGix.Native.discover(directory)
  end

  @doc """
  Try to open a git repository directly from the environment. If that fails, discover upwards from `directory` until one is found, while applying discovery options from the environment.
  """
  @spec discover_with_environment_overrides(String.t()) ::
          {:ok, reference()} | {:error, String.t()}
  def discover_with_environment_overrides(directory) when is_binary(directory) do
    ExGix.Native.discover_with_environment_overrides(directory)
  end

  @doc """
  The path to the `.git` directory itself, or equivalent if this is a bare repository.
  """
  @spec path(reference()) :: String.t()
  def path(repo) when is_reference(repo) do
    ExGix.Native.path(repo)
  end

  @doc """
  Return the path to the repository itself, containing objects, references, configuration, and more.
  Synonymous to `path/1`.
  """
  @spec git_dir(reference()) :: String.t()
  def git_dir(repo) when is_reference(repo) do
    path(repo)
  end

  @doc """
  Return the path to the working directory if this is not a bare repository.
  """
  @spec work_dir(reference()) :: String.t() | nil
  def work_dir(repo) when is_reference(repo) do
    ExGix.Native.work_dir(repo)
  end

  @doc """
  Return the path to the directory containing all objects.
  """
  @spec objects_dir(reference()) :: String.t()
  def objects_dir(repo) when is_reference(repo) do
    ExGix.Native.objects_dir(repo)
  end
end
