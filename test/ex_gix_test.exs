defmodule ExGixTest do
  use ExUnit.Case
  doctest ExGix

  test "open repo" do
    assert {:ok, repo} = ExGix.open(".")
    assert is_reference(repo)
  end

  test "open invalid repo" do
    assert {:error, _reason} = ExGix.open("/nonexistent/path/that/is/not/a/repo")
  end
end
