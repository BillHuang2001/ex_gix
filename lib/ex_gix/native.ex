defmodule ExGix.Native do
  version = Mix.Project.config()[:version]

  use RustlerPrecompiled,
    otp_app: :ex_gix,
    crate: "ex_gix",
    base_url: "https://github.com/BillHuang2001/ex_gix/releases/download/v#{version}",
    force_build: System.get_env("EX_GIX_BUILD") in ["1", "true"],
    version: version

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
  def head_tree_id(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def head_name(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def branch_names(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def remote_names(_resource), do: :erlang.nif_error(:nif_not_loaded)
  def cat_file(_resource, _revspec), do: :erlang.nif_error(:nif_not_loaded)
  def rev_parse(_resource, _revspec), do: :erlang.nif_error(:nif_not_loaded)
  def ls_tree(_resource, _revspec, _recursive), do: :erlang.nif_error(:nif_not_loaded)
  def status(_resource), do: :erlang.nif_error(:nif_not_loaded)

  def commit(_resource, _reference, _message, _tree, _parents),
    do: :erlang.nif_error(:nif_not_loaded)

  def commit_as(_resource, _committer, _author, _reference, _message, _tree, _parents),
    do: :erlang.nif_error(:nif_not_loaded)

  def new_commit(_resource, _message, _tree, _parents), do: :erlang.nif_error(:nif_not_loaded)

  def new_commit_as(_resource, _committer, _author, _message, _tree, _parents),
    do: :erlang.nif_error(:nif_not_loaded)

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
