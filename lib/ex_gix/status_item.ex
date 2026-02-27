defmodule ExGix.StatusItem do
  @moduledoc """
  Represents a single status item from the Git repository.
  """
  defstruct [:location, :path, :status]

  @type t :: %__MODULE__{
          location: :index_worktree | :tree_index,
          path: String.t(),
          status:
            :added
            | :deleted
            | :modified
            | :type_changed
            | :renamed
            | :copied
            | :untracked
            | :ignored
            | :conflict
            | :unknown
            | :rewrite
        }
end
