defmodule ExGix.ObjectDetached do
  @moduledoc """
  A detached, self-contained object, without access to its source repository.
  """

  @type t :: reference()
  @type kind :: :tree | :blob | :commit | :tag

  @doc """
  The id of the object.
  """
  @spec id(t()) :: ExGix.ObjectId.t()
  def id(object) when is_reference(object) do
    ExGix.Native.object_detached_id(object)
  end

  @doc """
  The kind of the object.
  """
  @spec kind(t()) :: kind()
  def kind(object) when is_reference(object) do
    ExGix.Native.object_detached_kind(object)
  end

  @doc """
  The fully decoded object data.
  """
  @spec data(t()) :: binary()
  def data(object) when is_reference(object) do
    ExGix.Native.object_detached_data(object)
  end
end
