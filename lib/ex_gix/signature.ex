defmodule ExGix.Signature do
  @moduledoc """
  Represents a Git actor's signature (author or committer).
  """
  defstruct [:name, :email, :time_seconds, :time_offset]

  @type t :: %__MODULE__{
          name: String.t(),
          email: String.t(),
          time_seconds: integer(),
          time_offset: integer()
        }
end
