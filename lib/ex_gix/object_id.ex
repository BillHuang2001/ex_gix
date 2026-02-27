defmodule ExGix.ObjectId do
  @moduledoc """
  A representation of an object hash, most commonly Sha1.
  """

  @type t :: reference()
  @type kind :: :sha1 | :sha256

  @doc """
  Create an instance from a buffer of 40 bytes or 64 bytes encoded with hexadecimal notation.
  """
  @spec from_hex(String.t()) :: {:ok, t()} | {:error, String.t()}
  def from_hex(hex) when is_binary(hex) do
    ExGix.Native.object_id_from_hex(hex)
  end

  @doc """
  Return a type which displays this oid as hex in full.
  """
  @spec to_hex(t()) :: String.t()
  def to_hex(object_id) when is_reference(object_id) do
    ExGix.Native.object_id_to_hex(object_id)
  end

  @doc """
  The kind of hash used for this instance.
  """
  @spec kind(t()) :: kind()
  def kind(object_id) when is_reference(object_id) do
    ExGix.Native.object_id_kind(object_id)
  end

  @doc """
  The hash of an empty blob.
  """
  @spec empty_blob(kind()) :: {:ok, t()} | {:error, String.t()}
  def empty_blob(kind \\ :sha1) when is_atom(kind) do
    ExGix.Native.object_id_empty_blob(kind)
  end

  @doc """
  The hash of an empty tree.
  """
  @spec empty_tree(kind()) :: {:ok, t()} | {:error, String.t()}
  def empty_tree(kind \\ :sha1) when is_atom(kind) do
    ExGix.Native.object_id_empty_tree(kind)
  end

  @doc """
  Returns an instances whose bytes are all zero.
  """
  @spec null(kind()) :: {:ok, t()} | {:error, String.t()}
  def null(kind \\ :sha1) when is_atom(kind) do
    ExGix.Native.object_id_null(kind)
  end

  @doc """
  Returns true if this hash consists of all null bytes.
  """
  @spec is_null(t()) :: boolean()
  def is_null(object_id) when is_reference(object_id) do
    ExGix.Native.object_id_is_null(object_id)
  end

  @doc """
  Returns true if this hash is equal to an empty blob.
  """
  @spec is_empty_blob(t()) :: boolean()
  def is_empty_blob(object_id) when is_reference(object_id) do
    ExGix.Native.object_id_is_empty_blob(object_id)
  end

  @doc """
  Returns true if this hash is equal to an empty tree.
  """
  @spec is_empty_tree(t()) :: boolean()
  def is_empty_tree(object_id) when is_reference(object_id) do
    ExGix.Native.object_id_is_empty_tree(object_id)
  end
end
