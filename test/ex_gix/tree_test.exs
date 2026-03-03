defmodule ExGix.TreeTest do
  use ExUnit.Case, async: true

  setup do
    dir = Path.join(System.tmp_dir!(), "ex_gix_tree_test_#{System.unique_integer([:positive])}")
    File.mkdir_p!(dir)

    {:ok, repo} = ExGix.Repository.init(dir)

    on_exit(fn ->
      File.rm_rf!(dir)
    end)

    %{repo: repo, dir: dir}
  end

  test "ls_tree returns an empty list for an empty tree", %{repo: repo} do
    # create a new empty tree and commit it
    {:ok, empty_tree} = ExGix.Native.object_id_empty_tree(:sha1)
    empty_tree_id = ExGix.Native.object_id_to_hex(empty_tree)

    {:ok, commit_id} = ExGix.Repository.new_commit(repo, "Initial commit", empty_tree_id, [])

    assert {:ok, []} = ExGix.Repository.ls_tree(repo, commit_id)
  end

  test "ls_tree returns items for a tree with files", %{repo: repo, dir: dir} do
    # Create some files
    File.write!(Path.join(dir, "file.txt"), "hello")
    File.write!(Path.join(dir, "executable.sh"), "echo hello")
    File.chmod!(Path.join(dir, "executable.sh"), 0o755)

    # Shell out to git to add and commit since we don't have high-level add/commit API for working tree
    System.cmd("git", ["-C", dir, "add", "."])
    System.cmd("git", ["-C", dir, "commit", "-m", "Initial commit"])

    # ls-tree HEAD
    assert {:ok, items} = ExGix.Repository.ls_tree(repo, "HEAD")

    # sort items by filename for reliable testing
    items = Enum.sort_by(items, & &1.filename)

    assert length(items) == 2

    # Check executable
    exe = Enum.find(items, &(&1.filename == "executable.sh"))
    assert exe.kind == :exe
    assert exe.mode == "100755"
    assert is_binary(exe.oid)

    # Check normal file
    file = Enum.find(items, &(&1.filename == "file.txt"))
    assert file.kind == :blob
    assert file.mode == "100644"
    assert is_binary(file.oid)
  end

  test "ls_tree works with nested folder structure", %{repo: repo, dir: dir} do
    # Create nested directories and files
    File.mkdir_p!(Path.join(dir, "foo/bar"))
    File.write!(Path.join(dir, "foo/bar/a.cpp"), "int main() {}")
    File.write!(Path.join(dir, "foo/b.txt"), "hello")

    System.cmd("git", ["-C", dir, "add", "."])
    System.cmd("git", ["-C", dir, "commit", "-m", "Nested commit"])

    # 1. Root level should have 'foo' as a tree
    assert {:ok, root_items} = ExGix.Repository.ls_tree(repo, "HEAD")
    foo_tree = Enum.find(root_items, &(&1.filename == "foo"))
    assert foo_tree != nil
    assert foo_tree.kind == :tree
    assert foo_tree.mode == "040000"

    # 2. 'foo' level should have 'bar' as a tree and 'b.txt' as a blob
    assert {:ok, foo_items} = ExGix.Repository.ls_tree(repo, "HEAD:foo")
    bar_tree = Enum.find(foo_items, &(&1.filename == "bar"))
    assert bar_tree != nil
    assert bar_tree.kind == :tree
    assert bar_tree.mode == "040000"

    b_txt = Enum.find(foo_items, &(&1.filename == "b.txt"))
    assert b_txt != nil
    assert b_txt.kind == :blob

    # 3. 'foo/bar' level should have 'a.cpp' as a blob
    assert {:ok, bar_items} = ExGix.Repository.ls_tree(repo, "HEAD:foo/bar")
    assert length(bar_items) == 1
    a_cpp = List.first(bar_items)
    assert a_cpp.filename == "a.cpp"
    assert a_cpp.kind == :blob
    assert a_cpp.mode == "100644"
  end
end
