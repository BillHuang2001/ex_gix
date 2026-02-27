use crate::object_id::ObjectIdResource;
use rustler::ResourceArc;

pub struct ObjectDetachedResource(pub gix::ObjectDetached);

rustler::atoms! {
    tree,
    blob,
    commit,
    tag,
}

pub fn kind_to_atom(kind: gix::object::Kind) -> rustler::Atom {
    match kind {
        gix::object::Kind::Tree => tree(),
        gix::object::Kind::Blob => blob(),
        gix::object::Kind::Commit => commit(),
        gix::object::Kind::Tag => tag(),
    }
}

#[rustler::nif]
pub fn object_detached_id(
    obj: ResourceArc<ObjectDetachedResource>,
) -> ResourceArc<ObjectIdResource> {
    ResourceArc::new(ObjectIdResource(obj.0.id))
}

#[rustler::nif]
pub fn object_detached_kind(obj: ResourceArc<ObjectDetachedResource>) -> rustler::Atom {
    kind_to_atom(obj.0.kind)
}

#[rustler::nif]
pub fn object_detached_data<'a>(
    env: rustler::Env<'a>,
    obj: ResourceArc<ObjectDetachedResource>,
) -> rustler::Binary<'a> {
    let slice = obj.0.data.as_slice();
    let mut erl_bin = rustler::OwnedBinary::new(slice.len()).unwrap();
    erl_bin.as_mut_slice().copy_from_slice(slice);
    erl_bin.release(env)
}
