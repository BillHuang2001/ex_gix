defmodule ExGix do
  @moduledoc """
  ExGix provides a native Rust implementation of Git for Elixir applications.
  """

  @doc """
  Opens a Git repository at the given path.

  ## Examples

      iex> {:ok, repo} = ExGix.open(".")
      iex> is_reference(repo)
      true

  """
  @spec open(String.t()) :: {:ok, reference()} | {:error, String.t()}
  def open(path) when is_binary(path) do
    ExGix.Native.open(path)
  end
end
