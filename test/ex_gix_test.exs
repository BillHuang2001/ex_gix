defmodule ExGixTest do
  use ExUnit.Case
  doctest ExGix

  test "open repo" do
    assert {:ok, repo} = ExGix.open(".")
    assert is_reference(repo)

    assert ExGix.path(repo) =~ ".git"
    assert ExGix.git_dir(repo) =~ ".git"
    assert is_binary(ExGix.objects_dir(repo))

    # work_dir could be nil for bare repo, but "." is not bare
    assert is_binary(ExGix.work_dir(repo))

    assert ExGix.is_bare(repo) == false
    assert ExGix.is_shallow(repo) == false

    assert {:ok, _id} = ExGix.head_id(repo)
    assert {:ok, _name} = ExGix.head_name(repo)

    assert is_list(ExGix.branch_names(repo))
    assert is_list(ExGix.remote_names(repo))
  end

  test "open invalid repo" do
    assert {:error, _reason} = ExGix.open("/nonexistent/path/that/is/not/a/repo")
  end

  test "discover repo" do
    assert {:ok, repo} = ExGix.discover("test")
    assert is_reference(repo)
    assert ExGix.path(repo) =~ ".git"
  end

  test "discover_with_environment_overrides repo" do
    assert {:ok, repo} = ExGix.discover_with_environment_overrides("test")
    assert is_reference(repo)
  end

  test "init repo" do
    # create a temporary directory
    path = Path.join(System.tmp_dir!(), "ex_gix_init_test_#{System.unique_integer([:positive])}")
    on_exit(fn -> File.rm_rf!(path) end)

    assert {:ok, repo} = ExGix.init(path)
    assert is_reference(repo)
    assert ExGix.path(repo) =~ ".git"
  end

  test "cat_file" do
    assert {:ok, repo} = ExGix.open(".")
    assert {:ok, content} = ExGix.cat_file(repo, "HEAD:README.md")
    assert is_binary(content)
    assert byte_size(content) > 0
    assert content =~ "ExGix"

    # Test with non-existent path
    assert {:error, _reason} = ExGix.cat_file(repo, "HEAD:nonexistent.txt")
  end

  test "rev_parse" do
    assert {:ok, repo} = ExGix.open(".")

    # Test resolving a commit
    assert {:ok, commit_id} = ExGix.rev_parse(repo, "HEAD")
    assert is_binary(commit_id)
    assert String.length(commit_id) == 40

    # Test resolving a tree
    assert {:ok, tree_id} = ExGix.rev_parse(repo, "HEAD^{tree}")
    assert is_binary(tree_id)
    assert String.length(tree_id) == 40

    # Test resolving a blob
    assert {:ok, blob_id} = ExGix.rev_parse(repo, "HEAD:README.md")
    assert is_binary(blob_id)
    assert String.length(blob_id) == 40

    # Test error handling
    assert {:error, _reason} = ExGix.rev_parse(repo, "nonexistent-branch-that-should-not-exist")
  end

  test "rev_parse combined with cat_file" do
    assert {:ok, repo} = ExGix.open(".")

    # First get the OID of a blob using rev_parse
    assert {:ok, blob_id} = ExGix.rev_parse(repo, "HEAD:README.md")

    # Then read the blob content by passing the OID to cat_file
    assert {:ok, content} = ExGix.cat_file(repo, blob_id)
    assert is_binary(content)
    assert content =~ "ExGix"
  end
end
