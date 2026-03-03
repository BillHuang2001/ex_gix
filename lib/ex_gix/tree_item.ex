defmodule ExGix.TreeItem do
  @moduledoc """
  Represents a single entry in a Git tree object.
  """
  @type t :: %__MODULE__{
          mode: String.t(),
          kind: atom(),
          filename: String.t(),
          oid: String.t()
        }

  defstruct [:mode, :kind, :filename, :oid]
end
