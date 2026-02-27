use rustler::{NifStruct, ResourceArc};

use crate::RepoResource;

#[derive(NifStruct)]
#[module = "ExGix.Signature"]
pub struct Signature {
    pub name: String,
    pub email: String,
    pub time_seconds: i64,
    pub time_offset: i32,
}

impl From<Signature> for gix::actor::Signature {
    fn from(sig: Signature) -> Self {
        gix::actor::Signature {
            name: sig.name.into(),
            email: sig.email.into(),
            time: gix::date::Time {
                seconds: sig.time_seconds,
                offset: sig.time_offset,
            },
        }
    }
}

#[rustler::nif(schedule = "DirtyIo")]
pub fn commit(
    resource: ResourceArc<RepoResource>,
    reference: String,
    message: String,
    tree: String,
    parents: Vec<String>,
) -> Result<String, String> {
    let repo = resource.repo.to_thread_local();

    let tree_id = gix::ObjectId::from_hex(tree.as_bytes()).map_err(|e| e.to_string())?;

    let mut parent_ids = Vec::new();
    for p in parents {
        let p_id = gix::ObjectId::from_hex(p.as_bytes()).map_err(|e| e.to_string())?;
        parent_ids.push(p_id);
    }

    match repo.commit(reference, message, tree_id, parent_ids) {
        Ok(id) => Ok(id.to_string()),
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif(schedule = "DirtyIo")]
pub fn commit_as(
    resource: ResourceArc<RepoResource>,
    committer: Signature,
    author: Signature,
    reference: String,
    message: String,
    tree: String,
    parents: Vec<String>,
) -> Result<String, String> {
    let repo = resource.repo.to_thread_local();

    let tree_id = gix::ObjectId::from_hex(tree.as_bytes()).map_err(|e| e.to_string())?;

    let mut parent_ids = Vec::new();
    for p in parents {
        let p_id = gix::ObjectId::from_hex(p.as_bytes()).map_err(|e| e.to_string())?;
        parent_ids.push(p_id);
    }

    let committer: gix::actor::Signature = committer.into();
    let author: gix::actor::Signature = author.into();

    let mut committer_time_buf = gix::date::parse::TimeBuf::default();
    let mut author_time_buf = gix::date::parse::TimeBuf::default();

    repo.commit_as(
        committer.to_ref(&mut committer_time_buf),
        author.to_ref(&mut author_time_buf),
        reference,
        message,
        tree_id,
        parent_ids,
    )
    .map(|id| id.to_string())
    .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyIo")]
pub fn new_commit(
    resource: ResourceArc<RepoResource>,
    message: String,
    tree: String,
    parents: Vec<String>,
) -> Result<String, String> {
    let repo = resource.repo.to_thread_local();

    let tree_id = gix::ObjectId::from_hex(tree.as_bytes()).map_err(|e| e.to_string())?;

    let mut parent_ids = Vec::new();
    for p in parents {
        let p_id = gix::ObjectId::from_hex(p.as_bytes()).map_err(|e| e.to_string())?;
        parent_ids.push(p_id);
    }

    repo.new_commit(message, tree_id, parent_ids)
        .map(|commit| commit.id().to_string())
        .map_err(|e| e.to_string())
}

#[rustler::nif(schedule = "DirtyIo")]
pub fn new_commit_as(
    resource: ResourceArc<RepoResource>,
    committer: Signature,
    author: Signature,
    message: String,
    tree: String,
    parents: Vec<String>,
) -> Result<String, String> {
    let repo = resource.repo.to_thread_local();

    let tree_id = gix::ObjectId::from_hex(tree.as_bytes()).map_err(|e| e.to_string())?;

    let mut parent_ids = Vec::new();
    for p in parents {
        let p_id = gix::ObjectId::from_hex(p.as_bytes()).map_err(|e| e.to_string())?;
        parent_ids.push(p_id);
    }

    let committer: gix::actor::Signature = committer.into();
    let author: gix::actor::Signature = author.into();

    let mut committer_time_buf = gix::date::parse::TimeBuf::default();
    let mut author_time_buf = gix::date::parse::TimeBuf::default();

    repo.new_commit_as(
        committer.to_ref(&mut committer_time_buf),
        author.to_ref(&mut author_time_buf),
        message,
        tree_id,
        parent_ids,
    )
    .map(|commit| commit.id().to_string())
    .map_err(|e| e.to_string())
}
