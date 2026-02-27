use rustler::ResourceArc;
use std::panic::AssertUnwindSafe;

use crate::RepoResource;

#[rustler::nif(schedule = "DirtyIo")]
pub fn open(path: String) -> Result<ResourceArc<RepoResource>, String> {
    match gix::open(&path) {
        Ok(repo) => {
            let resource = ResourceArc::new(RepoResource {
                repo: AssertUnwindSafe(repo.into_sync()),
            });
            Ok(resource)
        }
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif(schedule = "DirtyIo")]
pub fn discover(path: String) -> Result<ResourceArc<RepoResource>, String> {
    match gix::ThreadSafeRepository::discover(&path) {
        Ok(repo) => {
            let resource = ResourceArc::new(RepoResource {
                repo: AssertUnwindSafe(repo),
            });
            Ok(resource)
        }
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif(schedule = "DirtyIo")]
pub fn discover_with_environment_overrides(
    path: String,
) -> Result<ResourceArc<RepoResource>, String> {
    match gix::ThreadSafeRepository::discover_with_environment_overrides(&path) {
        Ok(repo) => {
            let resource = ResourceArc::new(RepoResource {
                repo: AssertUnwindSafe(repo),
            });
            Ok(resource)
        }
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif(schedule = "DirtyIo")]
pub fn init(path: String) -> Result<ResourceArc<RepoResource>, String> {
    match gix::init(&path) {
        Ok(repo) => {
            let resource = ResourceArc::new(RepoResource {
                repo: AssertUnwindSafe(repo.into_sync()),
            });
            Ok(resource)
        }
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif]
pub fn path(resource: ResourceArc<RepoResource>) -> String {
    resource.repo.path().to_string_lossy().to_string()
}

#[rustler::nif]
pub fn work_dir(resource: ResourceArc<RepoResource>) -> Option<String> {
    resource
        .repo
        .work_dir()
        .map(|p| p.to_string_lossy().to_string())
}

#[rustler::nif]
pub fn objects_dir(resource: ResourceArc<RepoResource>) -> String {
    resource.repo.objects_dir().to_string_lossy().to_string()
}

#[rustler::nif]
pub fn is_bare(resource: ResourceArc<RepoResource>) -> bool {
    let repo = resource.repo.to_thread_local();
    repo.is_bare()
}

#[rustler::nif]
pub fn is_shallow(resource: ResourceArc<RepoResource>) -> bool {
    let repo = resource.repo.to_thread_local();
    repo.is_shallow()
}

#[rustler::nif]
pub fn head_id(resource: ResourceArc<RepoResource>) -> Result<String, String> {
    let repo = resource.repo.to_thread_local();
    match repo.head_id() {
        Ok(id) => Ok(id.to_string()),
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif]
pub fn head_name(resource: ResourceArc<RepoResource>) -> Result<Option<String>, String> {
    let repo = resource.repo.to_thread_local();
    match repo.head_name() {
        Ok(Some(name)) => Ok(Some(name.to_string())),
        Ok(None) => Ok(None),
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif]
pub fn branch_names(resource: ResourceArc<RepoResource>) -> Vec<String> {
    let repo = resource.repo.to_thread_local();
    repo.branch_names()
        .into_iter()
        .map(|s| s.to_string())
        .collect()
}

#[rustler::nif]
pub fn remote_names(resource: ResourceArc<RepoResource>) -> Vec<String> {
    let repo = resource.repo.to_thread_local();
    repo.remote_names()
        .into_iter()
        .map(|s| s.to_string())
        .collect()
}
