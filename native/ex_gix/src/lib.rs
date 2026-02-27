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

#[allow(non_local_definitions)]
pub fn on_load(env: Env, _info: Term) -> bool {
    let _ = rustler::resource!(RepoResource, env);
    true
}

rustler::init!("Elixir.ExGix.Native", load = on_load);
