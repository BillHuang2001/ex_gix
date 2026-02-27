defmodule ExGix.Native do
  use Rustler, otp_app: :ex_gix, crate: "ex_gix"

  def open(_path), do: :erlang.nif_error(:nif_not_loaded)
end
