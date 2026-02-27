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
end
