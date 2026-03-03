defmodule ExGix.Repository do
  @moduledoc """
  Git repository related functions.
  """

  @doc """
  Opens a Git repository at the given path, possibly expanding it to `path/.git` if `path` is a work tree dir.

  ## Examples

      iex> {:ok, repo} = ExGix.Repository.open(".")
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

  @doc """
  Return true if this repository is bare.
  """
  @spec is_bare(reference()) :: boolean()
  def is_bare(repo) when is_reference(repo) do
    ExGix.Native.is_bare(repo)
  end

  @doc """
  Return true if the repository is a shallow clone.
  """
  @spec is_shallow(reference()) :: boolean()
  def is_shallow(repo) when is_reference(repo) do
    ExGix.Native.is_shallow(repo)
  end

  @doc """
  Resolve the HEAD reference and obtain its object id.
  """
  @spec head_id(reference()) :: {:ok, String.t()} | {:error, String.t()}
  def head_id(repo) when is_reference(repo) do
    ExGix.Native.head_id(repo)
  end

  @doc """
  Return the name to the symbolic reference HEAD points to, or nil if the head is detached.
  """
  @spec head_name(reference()) :: {:ok, String.t() | nil} | {:error, String.t()}
  def head_name(repo) when is_reference(repo) do
    ExGix.Native.head_name(repo)
  end

  @doc """
  Return a set of unique short branch names.
  """
  @spec branch_names(reference()) :: [String.t()]
  def branch_names(repo) when is_reference(repo) do
    ExGix.Native.branch_names(repo)
  end

  @doc """
  Returns a sorted list unique of symbolic names of remotes.
  """
  @spec remote_names(reference()) :: [String.t()]
  def remote_names(repo) when is_reference(repo) do
    ExGix.Native.remote_names(repo)
  end

  @doc """
  Gets the status of the repository, returning a list of `ExGix.StatusItem` structs.

  ## Examples

      iex> {:ok, repo} = ExGix.Repository.open("path/to/repo")
      iex> {:ok, statuses} = ExGix.Repository.status(repo)

  """
  @spec status(reference()) :: {:ok, [ExGix.StatusItem.t()]} | {:error, String.t()}
  def status(repo) when is_reference(repo) do
    ExGix.Native.status(repo)
  end

  @doc """
  Create a new commit object with message referring to tree with parents, and point reference to it.
  """
  @spec commit(reference(), String.t(), String.t(), String.t(), [String.t()]) ::
          {:ok, String.t()} | {:error, String.t()}
  def commit(repo, reference, message, tree, parents) when is_reference(repo) do
    ExGix.Native.commit(repo, reference, message, tree, parents)
  end

  @doc """
  Similar to commit/5, but allows to create the commit with committer and author specified.
  """
  @spec commit_as(
          reference(),
          ExGix.Signature.t(),
          ExGix.Signature.t(),
          String.t(),
          String.t(),
          String.t(),
          [String.t()]
        ) :: {:ok, String.t()} | {:error, String.t()}
  def commit_as(repo, committer, author, reference, message, tree, parents)
      when is_reference(repo) do
    ExGix.Native.commit_as(repo, committer, author, reference, message, tree, parents)
  end

  @doc """
  Create a new commit object and write it to the object database. Do not update any references.
  """
  @spec new_commit(reference(), String.t(), String.t(), [String.t()]) ::
          {:ok, String.t()} | {:error, String.t()}
  def new_commit(repo, message, tree, parents) when is_reference(repo) do
    ExGix.Native.new_commit(repo, message, tree, parents)
  end

  @doc """
  Create a new commit object using the specified committer and author, and write it to the object database. Do not update any references.
  """
  @spec new_commit_as(
          reference(),
          ExGix.Signature.t(),
          ExGix.Signature.t(),
          String.t(),
          String.t(),
          [String.t()]
        ) :: {:ok, String.t()} | {:error, String.t()}
  def new_commit_as(repo, committer, author, message, tree, parents) when is_reference(repo) do
    ExGix.Native.new_commit_as(repo, committer, author, message, tree, parents)
  end

  @doc """
  Output the content of a blob object.
  """
  @spec cat_file(reference(), String.t()) ::
          {:ok, binary()} | {:error, String.t()}
  def cat_file(repo, revspec)
      when is_reference(repo) and is_binary(revspec) do
    ExGix.Native.cat_file(repo, revspec)
  end

  @doc """
  Find the object id for the given revision string.
  """
  @spec rev_parse(reference(), String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def rev_parse(repo, revspec) when is_reference(repo) and is_binary(revspec) do
    ExGix.Native.rev_parse(repo, revspec)
  end

  @doc """
  List the contents of a tree object, similar to `git ls-tree`.
  """
  @spec ls_tree(reference(), String.t()) :: {:ok, [ExGix.TreeItem.t()]} | {:error, String.t()}
  def ls_tree(repo, revspec) when is_reference(repo) and is_binary(revspec) do
    ExGix.Native.ls_tree(repo, revspec)
  end
end
