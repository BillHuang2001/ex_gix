defmodule ExGix.Native do
  use Rustler, otp_app: :ex_gix, crate: "ex_gix"

  def open(_path), do: :erlang.nif_error(:nif_not_loaded)
  def init(_path), do: :erlang.nif_error(:nif_not_loaded)
  def discover(_path), do: :erlang.nif_error(:nif_not_loaded)
  def discover_with_environment_overrides(_path), do: :erlang.nif_error(:nif_not_loaded)

  def path(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def work_dir(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def objects_dir(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def is_bare(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def is_shallow(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def head_id(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def head_name(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def branch_names(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def remote_names(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def cat_file(_resource, _revspec), do: :erlang.nif_error(:nif_not_loaded)

  def object_id_from_hex(_hex), do: :erlang.nif_error(:nif_not_loaded)
  def object_id_to_hex(_id), do: :erlang.nif_error(:nif_not_loaded)
  def object_id_kind(_id), do: :erlang.nif_error(:nif_not_loaded)
  def object_id_empty_blob(_kind), do: :erlang.nif_error(:nif_not_loaded)
  def object_id_empty_tree(_kind), do: :erlang.nif_error(:nif_not_loaded)
  def object_id_null(_kind), do: :erlang.nif_error(:nif_not_loaded)
  def object_id_is_null(_id), do: :erlang.nif_error(:nif_not_loaded)
  def object_id_is_empty_blob(_id), do: :erlang.nif_error(:nif_not_loaded)
  def object_id_is_empty_tree(_id), do: :erlang.nif_error(:nif_not_loaded)

  def object_detached_id(_obj), do: :erlang.nif_error(:nif_not_loaded)
  def object_detached_kind(_obj), do: :erlang.nif_error(:nif_not_loaded)
  def object_detached_data(_obj), do: :erlang.nif_error(:nif_not_loaded)
end
