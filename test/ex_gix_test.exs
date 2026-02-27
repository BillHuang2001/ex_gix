defmodule ExGixTest do
  use ExUnit.Case
  doctest ExGix

  test "greets the world" do
    assert ExGix.hello() == :world
  end
end
