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

#[allow(non_local_definitions)]
pub fn on_load(env: Env, _info: Term) -> bool {
    let _ = rustler::resource!(RepoResource, env);
    true
}

rustler::init!("Elixir.ExGix.Native", load = on_load);
