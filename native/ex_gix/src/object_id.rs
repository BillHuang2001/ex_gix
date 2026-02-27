use rustler::ResourceArc;

pub struct ObjectIdResource(pub gix::ObjectId);

rustler::atoms! {
    sha1,
    sha256,
}

fn atom_to_kind(atom: rustler::Atom) -> Result<gix::hash::Kind, String> {
    if atom == sha1() {
        Ok(gix::hash::Kind::Sha1)
    } else {
        Err(format!("Unsupported hash kind"))
    }
}

fn kind_to_atom(kind: gix::hash::Kind) -> rustler::Atom {
    match kind {
        gix::hash::Kind::Sha1 => sha1(),
        _ => sha1(), // default to sha1
    }
}

#[rustler::nif]
pub fn object_id_from_hex(hex: String) -> Result<ResourceArc<ObjectIdResource>, String> {
    match gix::ObjectId::from_hex(hex.as_bytes()) {
        Ok(id) => Ok(ResourceArc::new(ObjectIdResource(id))),
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif]
pub fn object_id_to_hex(id: ResourceArc<ObjectIdResource>) -> String {
    id.0.to_hex().to_string()
}

#[rustler::nif]
pub fn object_id_kind(id: ResourceArc<ObjectIdResource>) -> rustler::Atom {
    kind_to_atom(id.0.kind())
}

#[rustler::nif]
pub fn object_id_empty_blob(kind: rustler::Atom) -> Result<ResourceArc<ObjectIdResource>, String> {
    let k = atom_to_kind(kind)?;
    Ok(ResourceArc::new(ObjectIdResource(
        gix::ObjectId::empty_blob(k),
    )))
}

#[rustler::nif]
pub fn object_id_empty_tree(kind: rustler::Atom) -> Result<ResourceArc<ObjectIdResource>, String> {
    let k = atom_to_kind(kind)?;
    Ok(ResourceArc::new(ObjectIdResource(
        gix::ObjectId::empty_tree(k),
    )))
}

#[rustler::nif]
pub fn object_id_null(kind: rustler::Atom) -> Result<ResourceArc<ObjectIdResource>, String> {
    let k = atom_to_kind(kind)?;
    Ok(ResourceArc::new(ObjectIdResource(gix::ObjectId::null(k))))
}

#[rustler::nif]
pub fn object_id_is_null(id: ResourceArc<ObjectIdResource>) -> bool {
    id.0.is_null()
}

#[rustler::nif]
pub fn object_id_is_empty_blob(id: ResourceArc<ObjectIdResource>) -> bool {
    id.0.is_empty_blob()
}

#[rustler::nif]
pub fn object_id_is_empty_tree(id: ResourceArc<ObjectIdResource>) -> bool {
    id.0.is_empty_tree()
}
