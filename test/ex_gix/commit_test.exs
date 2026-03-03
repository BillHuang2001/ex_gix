defmodule ExGix.CommitTest do
  use ExUnit.Case, async: true

  setup do
    tmp_dir =
      Path.join(System.tmp_dir!(), "ex_gix_commit_test_#{System.unique_integer([:positive])}")

    File.mkdir_p!(tmp_dir)
    System.cmd("git", ["init"], cd: tmp_dir)

    {:ok, repo} = ExGix.Repository.open(tmp_dir)

    on_exit(fn ->
      File.rm_rf!(tmp_dir)
    end)

    %{repo: repo, dir: tmp_dir}
  end

  test "commits changes to repository", %{repo: repo, dir: dir} do
    # Add a file using git cli to have something to commit
    File.write!(Path.join(dir, "file.txt"), "content")
    System.cmd("git", ["add", "file.txt"], cd: dir)

    # Make an initial commit via CLI
    {_out, 0} = System.cmd("git", ["commit", "-m", "init"], cd: dir)

    # Verify head_tree_id matches git cli
    {:ok, head_id} = ExGix.Repository.head_id(repo)
    {tree_out, 0} = System.cmd("git", ["log", "-1", "--pretty=%T", head_id], cd: dir)
    tree_id = String.trim(tree_out)
    assert {:ok, ^tree_id} = ExGix.Repository.head_tree_id(repo)

    sig = %ExGix.Signature{
      name: "Test Committer",
      email: "test@example.com",
      time_seconds: 1_677_685_600,
      time_offset: 0
    }

    assert {:ok, _new_commit_id} =
             ExGix.Repository.commit_as(
               repo,
               sig,
               sig,
               "Test commit message"
             )

    # verify the commit was created
    {log_out, 0} = System.cmd("git", ["log", "-1", "--pretty=%s"], cd: dir)
    assert String.trim(log_out) == "Test commit message"

    {author_out, 0} = System.cmd("git", ["log", "-1", "--pretty=%an <%ae>"], cd: dir)
    assert String.trim(author_out) == "Test Committer <test@example.com>"
  end
end
