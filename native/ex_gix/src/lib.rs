use rustler::{Env, ResourceArc, Term};
use std::panic::AssertUnwindSafe;

pub struct RepoResource {
    pub repo: AssertUnwindSafe<gix::ThreadSafeRepository>,
}

#[rustler::nif(schedule = "DirtyIo")]
fn open(path: String) -> Result<ResourceArc<RepoResource>, String> {
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
fn discover(path: String) -> Result<ResourceArc<RepoResource>, String> {
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
fn discover_with_environment_overrides(path: String) -> Result<ResourceArc<RepoResource>, String> {
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
fn init(path: String) -> Result<ResourceArc<RepoResource>, String> {
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
fn path(resource: ResourceArc<RepoResource>) -> String {
    resource.repo.path().to_string_lossy().to_string()
}

#[rustler::nif]
fn work_dir(resource: ResourceArc<RepoResource>) -> Option<String> {
    resource
        .repo
        .work_dir()
        .map(|p| p.to_string_lossy().to_string())
}

#[rustler::nif]
fn objects_dir(resource: ResourceArc<RepoResource>) -> String {
    resource.repo.objects_dir().to_string_lossy().to_string()
}

#[rustler::nif]
fn is_bare(resource: ResourceArc<RepoResource>) -> bool {
    let repo = resource.repo.to_thread_local();
    repo.is_bare()
}

#[rustler::nif]
fn is_shallow(resource: ResourceArc<RepoResource>) -> bool {
    let repo = resource.repo.to_thread_local();
    repo.is_shallow()
}

#[rustler::nif]
fn head_id(resource: ResourceArc<RepoResource>) -> Result<String, String> {
    let repo = resource.repo.to_thread_local();
    match repo.head_id() {
        Ok(id) => Ok(id.to_string()),
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif]
fn head_name(resource: ResourceArc<RepoResource>) -> Result<Option<String>, String> {
    let repo = resource.repo.to_thread_local();
    match repo.head_name() {
        Ok(Some(name)) => Ok(Some(name.to_string())),
        Ok(None) => Ok(None),
        Err(e) => Err(e.to_string()),
    }
}

#[rustler::nif]
fn branch_names(resource: ResourceArc<RepoResource>) -> Vec<String> {
    let repo = resource.repo.to_thread_local();
    repo.branch_names()
        .into_iter()
        .map(|s| s.to_string())
        .collect()
}

#[rustler::nif]
fn remote_names(resource: ResourceArc<RepoResource>) -> Vec<String> {
    let repo = resource.repo.to_thread_local();
    repo.remote_names()
        .into_iter()
        .map(|s| s.to_string())
        .collect()
}

#[allow(non_local_definitions)]
pub fn on_load(env: Env, _info: Term) -> bool {
    let _ = rustler::resource!(RepoResource, env);
    true
}

rustler::init!("Elixir.ExGix.Native", load = on_load);
