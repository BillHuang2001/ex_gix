defmodule ExGix.ObjectIdTest do
  use ExUnit.Case

  alias ExGix.ObjectId

  test "from_hex and to_hex" do
    # empty tree
    hex = "e69de29bb2d1d6434b8b29ae775ad8c2e48c5391"
    assert {:ok, oid} = ObjectId.from_hex(hex)
    assert is_reference(oid)
    assert ObjectId.to_hex(oid) == hex
    assert ObjectId.kind(oid) == :sha1
  end

  test "empty_blob" do
    assert {:ok, oid} = ObjectId.empty_blob()
    assert is_reference(oid)
    assert ObjectId.is_empty_blob(oid) == true
    assert ObjectId.is_empty_tree(oid) == false
    assert ObjectId.is_null(oid) == false
  end

  test "empty_tree" do
    assert {:ok, oid} = ObjectId.empty_tree()
    assert is_reference(oid)
    assert ObjectId.is_empty_tree(oid) == true
    assert ObjectId.is_empty_blob(oid) == false
    assert ObjectId.is_null(oid) == false
  end

  test "null" do
    assert {:ok, oid} = ObjectId.null()
    assert is_reference(oid)
    assert ObjectId.is_null(oid) == true
    assert ObjectId.is_empty_blob(oid) == false
    assert ObjectId.is_empty_tree(oid) == false
  end

  test "invalid hex" do
    assert {:error, _} = ObjectId.from_hex("invalid")
  end
end
