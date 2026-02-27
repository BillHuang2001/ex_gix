# ExGix Developer & Agent Guidelines

## Design Philosophy & Architecture

### API Design Principles

- **Idiomatic Elixir:** The public API should feel natural to Elixir developers, using familiar patterns and conventions. For example, we prefer returning `{:ok, result}` or `{:error, reason}` tuples instead of raising exceptions.
- **High-Level Abstractions:** We aim to provide high-level operations mirroring common Git workflows. Low-level operations will be encapsulated in the Rust layer, while the Elixir API focuses on ease of use and composability.

### The `ThreadSafeRepository` Factory Pattern

We use `gix::ThreadSafeRepository` as a factory object inside the `RepoResource` Rustler resource.

1. **Panic Safety via Zero-Cost Abstraction:**
   Because Erlang VM crashes if a NIF panics, Rustler wraps NIF invocations in `std::panic::catch_unwind`, which requires variables passing the boundary to be `RefUnwindSafe`. `gix::ThreadSafeRepository` uses internal mutability constructs not marked as `RefUnwindSafe`.
   Instead of wrapping the repository in a `std::sync::Mutex` (which introduces locking overhead that bottlenecks the parallel Erlang scheduler), we wrap it in `std::panic::AssertUnwindSafe`. This is a zero-cost abstraction that asserts to the compiler that the repository is safe to cross the panic boundary.

2. **Thread-Local Repository Instances:**
   The `ThreadSafeRepository` instance is *never* used directly to perform operations. Instead, inside each Rust function (NIF) that accepts the repository resource, we immediately call `resource.repo.to_thread_local()` to generate a lightweight, thread-local `gix::Repository` instance.

   ```rust
   // Example of usage inside a NIF:
   #[rustler::nif(schedule = "DirtyIo")]
   fn do_something(resource: ResourceArc<RepoResource>) -> Result<Atom, String> {
       // Create a thread-local Repository from the AssertUnwindSafe<ThreadSafeRepository> wrapper
       let local_repo = resource.repo.0.to_thread_local();

       // Use local_repo for fast, lock-free operations...
       Ok(atoms::ok())
   }
   ```

### Working with Rustler NIFs

- **Scheduling:** Always use `#[rustler::nif(schedule = "DirtyIo")]` or `DirtyCpu` for Git operations to prevent blocking the main Erlang scheduler threads, as file system reads and object lookups can be blocking.
- **Object Lifetimes:** Since elixir uses immutable data structures, only immutable references can be safely passed into Rust. To avoid unnecessary cloning, we should design our high-level API to accept simple identifiers (like object IDs or paths) and perform lookups inside the Rust layer, where we can manage lifetimes more efficiently.
- **Garbage Collection:** We do not provide an explicit `close/1` function for the repository. We rely on the Erlang garbage collector (GC) dropping the `ResourceArc` when it goes out of scope, which cleanly triggers the underlying Rust `Drop` trait for the repository.
