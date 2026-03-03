use rustler::{Env, Term};
use std::panic::AssertUnwindSafe;

pub mod commit;
pub mod object_detached;
pub mod object_id;
pub mod repository;
pub mod status;
pub mod tree;

pub struct RepoResource {
    pub repo: AssertUnwindSafe<gix::ThreadSafeRepository>,
}

#[allow(non_local_definitions)]
pub fn on_load(env: Env, _info: Term) -> bool {
    let _ = rustler::resource!(RepoResource, env);
    let _ = rustler::resource!(object_id::ObjectIdResource, env);
    let _ = rustler::resource!(object_detached::ObjectDetachedResource, env);
    true
}

rustler::init!("Elixir.ExGix.Native", load = on_load);
