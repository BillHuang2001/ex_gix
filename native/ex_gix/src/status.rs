use gix::status::index_worktree::Item as WtItem;
use rustler::{Atom, NifStruct, ResourceArc};

use crate::RepoResource;

mod atoms {
    rustler::atoms! {
        ok,
        error,
        index_worktree,
        tree_index,
        added,
        deleted,
        modified,
        type_changed,
        renamed,
        copied,
        untracked,
        ignored,
        conflict,
        unknown,
        rewrite
    }
}

#[derive(NifStruct)]
#[module = "ExGix.StatusItem"]
pub struct StatusItem {
    pub location: Atom,
    pub path: String,
    pub status: Atom,
}

#[rustler::nif(schedule = "DirtyIo")]
pub fn status(resource: ResourceArc<RepoResource>) -> Result<Vec<StatusItem>, String> {
    let repo = resource.repo.to_thread_local();

    let platform = repo
        .status(gix::progress::Discard)
        .map_err(|e| e.to_string())?;
    let iter = platform
        .into_iter(std::iter::empty::<gix::bstr::BString>())
        .map_err(|e| e.to_string())?;

    let mut items = Vec::new();

    for item in iter {
        let item = item.map_err(|e| e.to_string())?;
        match item {
            gix::status::Item::IndexWorktree(change) => match change {
                WtItem::Modification {
                    rela_path, status, ..
                } => {
                    let status_str = format!("{:?}", status);
                    let status_atom = if status_str.contains("Removed") {
                        atoms::deleted()
                    } else if status_str.contains("Type") {
                        atoms::type_changed()
                    } else {
                        atoms::modified()
                    };
                    items.push(StatusItem {
                        location: atoms::index_worktree(),
                        path: rela_path.to_string(),
                        status: status_atom,
                    });
                }
                WtItem::DirectoryContents { entry, .. } => {
                    let status_str = format!("{:?}", entry.status);
                    let status_atom = if status_str.contains("Untracked") {
                        atoms::untracked()
                    } else if status_str.contains("Ignored") {
                        atoms::ignored()
                    } else {
                        atoms::unknown()
                    };
                    items.push(StatusItem {
                        location: atoms::index_worktree(),
                        path: entry.rela_path.to_string(),
                        status: status_atom,
                    });
                }
                WtItem::Rewrite { source, .. } => {
                    let path = source.rela_path().to_string();
                    items.push(StatusItem {
                        location: atoms::index_worktree(),
                        path,
                        status: atoms::rewrite(),
                    });
                }
            },
            gix::status::Item::TreeIndex(change) => match change {
                gix::diff::index::Change::Addition { location, .. } => {
                    items.push(StatusItem {
                        location: atoms::tree_index(),
                        path: location.to_string(),
                        status: atoms::added(),
                    });
                }
                gix::diff::index::Change::Deletion { location, .. } => {
                    items.push(StatusItem {
                        location: atoms::tree_index(),
                        path: location.to_string(),
                        status: atoms::deleted(),
                    });
                }
                gix::diff::index::Change::Modification { location, .. } => {
                    items.push(StatusItem {
                        location: atoms::tree_index(),
                        path: location.to_string(),
                        status: atoms::modified(),
                    });
                }
                gix::diff::index::Change::Rewrite { location, .. } => {
                    items.push(StatusItem {
                        location: atoms::tree_index(),
                        path: location.to_string(),
                        status: atoms::rewrite(),
                    });
                }
            },
        }
    }

    Ok(items)
}
