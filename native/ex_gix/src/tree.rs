use crate::RepoResource;
use rustler::{Atom, NifStruct, ResourceArc};

mod atoms {
    rustler::atoms! {
        tree,
        blob,
        exe,
        link,
        commit,
    }
}

#[derive(NifStruct)]
#[module = "ExGix.TreeItem"]
pub struct TreeItem {
    pub mode: String,
    pub kind: Atom,
    pub filename: String,
    pub oid: String,
}

#[rustler::nif(schedule = "DirtyIo")]
pub fn ls_tree(
    resource: ResourceArc<RepoResource>,
    revspec: String,
    recursive: bool,
) -> Result<Vec<TreeItem>, String> {
    let repo = resource.repo.to_thread_local();

    let spec = repo
        .rev_parse(revspec.as_str())
        .map_err(|e| e.to_string())?;

    let object_id = spec
        .single()
        .ok_or_else(|| "Not a single object".to_string())?;

    let object = object_id.object().map_err(|e| e.to_string())?;

    let tree = object.peel_to_tree().map_err(|e| e.to_string())?;

    let mut items = Vec::new();

    if recursive {
        let files = tree
            .traverse()
            .breadthfirst
            .files()
            .map_err(|e| e.to_string())?;

        for file in files {
            let kind = match file.mode.kind() {
                gix::objs::tree::EntryKind::Tree => atoms::tree(),
                gix::objs::tree::EntryKind::Blob => atoms::blob(),
                gix::objs::tree::EntryKind::BlobExecutable => atoms::exe(),
                gix::objs::tree::EntryKind::Link => atoms::link(),
                gix::objs::tree::EntryKind::Commit => atoms::commit(),
            };

            let mode_str = format!("{:06o}", file.mode.value());

            items.push(TreeItem {
                mode: mode_str,
                kind,
                filename: file.filepath.to_string(),
                oid: file.oid.to_string(),
            });
        }
    } else {
        for entry in tree.iter() {
            let entry = entry.map_err(|e| e.to_string())?;

            let kind = match entry.mode().kind() {
                gix::objs::tree::EntryKind::Tree => atoms::tree(),
                gix::objs::tree::EntryKind::Blob => atoms::blob(),
                gix::objs::tree::EntryKind::BlobExecutable => atoms::exe(),
                gix::objs::tree::EntryKind::Link => atoms::link(),
                gix::objs::tree::EntryKind::Commit => atoms::commit(),
            };

            // Standard git mode format string
            let mode_str = format!("{:06o}", entry.mode().value());

            items.push(TreeItem {
                mode: mode_str,
                kind,
                filename: entry.filename().to_string(),
                oid: entry.id().to_string(),
            });
        }
    }

    Ok(items)
}
