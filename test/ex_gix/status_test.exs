defmodule ExGix.StatusTest do
  use ExUnit.Case, async: true

  setup do
    tmp_dir =
      Path.join(System.tmp_dir!(), "ex_gix_status_test_#{System.unique_integer([:positive])}")

    File.mkdir_p!(tmp_dir)
    System.cmd("git", ["init"], cd: tmp_dir)

    {:ok, repo} = ExGix.Repository.open(tmp_dir)

    on_exit(fn ->
      File.rm_rf!(tmp_dir)
    end)

    %{repo: repo, dir: tmp_dir}
  end

  test "returns empty list for clean repo", %{repo: repo} do
    assert {:ok, []} = ExGix.Repository.status(repo)
  end

  test "returns untracked file status", %{repo: repo, dir: dir} do
    File.write!(Path.join(dir, "new_file.txt"), "hello")

    assert {:ok,
            [
              %ExGix.StatusItem{
                location: :index_worktree,
                path: "new_file.txt",
                status: :untracked
              }
            ]} =
             ExGix.Repository.status(repo)
  end

  test "returns modified file status", %{repo: repo, dir: dir} do
    file_path = Path.join(dir, "tracked.txt")
    File.write!(file_path, "v1")
    System.cmd("git", ["add", "tracked.txt"], cd: dir)
    System.cmd("git", ["commit", "-m", "init"], cd: dir)

    assert {:ok, []} = ExGix.Repository.status(repo)

    File.write!(file_path, "v2")

    assert {:ok,
            [%ExGix.StatusItem{location: :index_worktree, path: "tracked.txt", status: :modified}]} =
             ExGix.Repository.status(repo)
  end

  test "returns added file status from index", %{repo: repo, dir: dir} do
    File.write!(Path.join(dir, "staged.txt"), "staged")
    System.cmd("git", ["add", "staged.txt"], cd: dir)

    assert {:ok, [%ExGix.StatusItem{location: :tree_index, path: "staged.txt", status: :added}]} =
             ExGix.Repository.status(repo)
  end
end
