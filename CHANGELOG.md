## v0.14.1

* Admin UI:
  * Fix Record API id constraints to allow any UUID after v0.14.0 update.
  * Add more curl examples for record create/update/delete.
  * Fix and improve default value construction.
* More permissive default CORS, allow any headers.
* Update JS dependencies.

## v0.14.0

* Allow truly random UUIDv4 record IDs by relying on AES encrypted `_rowid_`s
  for cursors. UUIDv7, while great, has the problem of leaking creation-time.
  * Note: the encryption key for cursors is tied to the instance lifetime, i.e.
    they cannot be used across instance restarts (at least for now).
* Move user ids to UUIDv4 by default to avoid leaking user creation-time.
  * A bundled schema migration will update the PK to allow any UUID type, this is
    mostly to allow for existing users with UUIDv7 ids to continue to exist.
  * We expect this change to be transparent for most users but may break you,
    if you're relying on user ids being of the UUIDv7. Sorry, we felt this was an
    important change and wanted to rip off the band-aid. If you're having issues
    and are unsure on how to address them, please reach out and we'll help.

## v0.13.3

* Improve RecordAPI settings sheet with tabs, help text, and curl examples.
* Fix state update on key-stroke for input fields in admin UI.
* Minor: inline filter examples.
* Update Rust dependencies.

## v0.13.2

* Fix Admin-UI login form reactivity issue.

## v0.13.1

* Fix index names in admin UI.
* Update JS & Rust dependencies.

## v0.13.0

* Improve authentication and avatar handling (breaking).
  * Remove avatar handling dependence on *special* `_user_avatar` record API by introducing dedicaed APIs.
    This is a breaking change to the semantics of `/api/auth/v1/avatar*`, which
    affects users of said APIs or `client.avatarUrl()`. Make sure to update to
    the latest JS/TS client (v0.6).
  * We also recommend removing the `_user_avatar` API definition from your `<traildepot>/config.textproto`.
    It's inconsequential to have but no longer needed.
  * Further, `/api/auth/v1/status` will now also refresh tokens thus not only
    validating the auth token but also the session. The JS/TS client uses this to
    asynchronously validate provided tokens.
  * Allow deletion of avatars on `/_/auth/profile`. Also adopt nanostores to
    manage client/user state on the profiles page.
  * Add avatars back to admin UI.
  * Document auth token lifecycle expectations when persisting tokens.
* Update dependencies.

## v0.12.3

* Fix row insertion/update in admin dashboard.
* Fall back to downloading JS deps during build when missing. This helps with vendoring TrailBase for framework use-cases.
* Update dependencies.

## v0.12.2

* Fix unchecked null assertion in admin auth dashboard.
* Update JS dependencies.

## v0.12.1

* Use fully-qualified databases everywhere. Preparation for multi-DB.
* Support for for Maxmind's city-geoip DB and command line to specificy custom
  DB locations.
* Explicitly parse cursor based on schema.
* Show command line in admin dashboard
* Improve admin dash's state management .
* Internal: Reduce dependene on vendored crates.
* Update dependencies including latest version of SQLite.

## v0.12.0

* Overhaul list API filters to allow for nested, complex expressions. The query
  parameters change making is a **breaking** change. Users will need to update
  their client libraries.
  * All clients have been updated to both: support the new syntax and help in
    the construction of nested filters.
  * For raw HTTP users, the filter format went from `col[ne]=val` to
    `filter[col][$ne]=val` following QS conventions.
  * For example, exluding a range of values `[v_min, v_max]`:
    `?filter[$or][0][col][$gt]=v_max&filter[$or][1][col][$lt]=v_min`.
* A new client implementation for the Swift language.
* Show release version in the admin dashboard and link to release page.
* Update dependencies.

## v0.11.5

* Improved admin SQL editor: save dialog and pending change indication.
* Fix short-cut links on dashboard landing page.
* Update dependencies.

## v0.11.4

* Replaced Mermaid-based schema renderer with x6.
* Fix admin UI create-table regression.

## v0.11.3

* Add simple schema visualizer to admin UI. This is a starting point.
* Configurable password policies: length, characters, ...
* Turn admin UI's landing page into more of a dashboard, i.e. provide some
  quick numbers on DB size, num users, ...
* Some small fixes and internal cleanups, e.g. preserve `redirect_to`, simplify
  state management, ...
* Update dependencies.

## v0.11.2

* Rate-limit failed login attempts to protect against brute force.
* Add option to disallow password-based sign-up.
* Fix 404 content-type.
* Fix escaping of hidden form state in auth UI after moving to askama templates.
* Update dependencies.

## v0.11.1

* While JS transactions are waiting for a DB lock, periodically yield back to
  the event loop to allow it to make progress.
* Allow using foreign key expansion on record APIs backed by `VIEW`s.

## v0.11.0

* Support SQLite transactions from JS/TS, e.g.:
  ```ts
    import { transaction, Transaction } from "../trailbase.js";

    await transaction((tx: Transaction) => {
      tx.execute("INSERT INTO 'table0' (v) VALUES (5)", []);
      tx.execute("INSERT INTO 'table1' (v) VALUES (23)", []);
      tx.commit();
    });
  ```
  WARN: This will block the event-loop until a lock on the underlying database
  connection can be acquired. This may become a bottleneck if there's a lot of
  write congestion. The API is already async to transparently update the
  implementation in the future.
* Update rusqlite to v0.35. On of the major changes is that rusqlite will no
  longer quietly ignore statements beyond the first. This makes a lot of sense
  but is a breaking change, if you were previously relying on this this odd
  behavior.
* Overhaul JS runtime integration: separate crate, unified execution model, use
  kanal and more tests.
* Added `trailbase_sqlite::Connection::write_lock()` API to get a lock on the
  underlying connection to support JS transactions in a way that is compatible
  with realtime subscriptions w/o blocking the SQLite writer thread for
  extended periods of time while deferring control to JS.
* Fix benign double slash in some urls.
* Minor: improve internal migration writer.
* Update other dependencies.

## v0.10.1

* Further refine SQLite execution model.
  * Previously reader/writer queues were processed independently. That's great
    for naive benchmarks but not ideal for more real-world, mixed workloads.
  * Use an in-process RwLock to orchestrate access avoiding file-lock congestion.
* Improve Record listing:
  * Support `?offset=N` based pagination. Cursor will always be more efficient when applicable.
  * Updated all the clients to support offset.
  * Error on in-applicable cursors.
  * Error on user-provided `?limit=N`s exceeding the hard limit.
* Fix corner cases for not properly escaped and not fully-qualified filter column names.
* Update dependencies.

## v0.10.0

* Finer-grained access control over exposed APIs on a per-column basis:
  * Columns can be explicitly excluded via a `excluded_columns` config option
    rendering them inaccessible for both: reads and writes. This is different
    from columns prefixed with "_", which are only hidden from read operations.
  * A new `_REQ_FIELDS_` table is availble during access checks for `UPDATE` and
    `CREATE` endpoints allowing to check for field presence in requests, e.g.
    `'field' IN _REQ_FIELDS_`. A field in `_REQ`_ will be `NULL` whether it was
    absent or explicitly passed as `null`.
* Early message queue work (WIP).
* Updated dependencies.

## v0.9.4

* Overhaul insert/update row/record form:
  * Integer primary keys are nullable.
  * Explicit nullability for numbers.
  * Ignore defaults for update path.
  * Don't pre-fill defaults.
* Install SIGHUP handler for config reload.
* Update to Rust edition 2024.
* Update dependencies.

## v0.9.3

* Custom JSON stdout request logger to have a stable format as opposed to
  depending on the span/event structure, which is an implementation detail.
* Show response timestamps in dashboard with millisecond resolution.
* Log response timestamp explicitly.
* Improve logs writer performance: no transaction needed, improved statement
  caching.
* Improve incremental release build times by ~70% switching from "fat" to "thin" LTO.
* Update dependencies.

## v0.9.2

* Overhaul SQLite execution model to allow for parallel reads. This should help
  reduce latency long-tail with slow queries.
  * And add more benchmarks.
* Log request/response logs to stdout in JSON format.
* Always re-create traildepot/.gitignore. Previously gated on creating the root
  path, which was never the case for docker users.
* Update dependencies.

## v0.9.1

* Consistently expanded JSON schemas for specific APIs everywhere (UI & CLI).
* Improved foreign table id lookup during schema evaluation.
* Stricter SQL validation in admin UI.
* Break up sqlite and core creates into two additional crates: schema & assets.
* Update dependencies.

## v0.9.0

* Performance:
  * Read and write latency improved both by ~30% 🔥.
  * Memory footprint dropped by ~20% in our insert benchmarks.
  * Build narrower INSERT queries.
  * Use more cached statements.
* Overhaul object-store/S3 file life-cycle/cleanup.
  * Use triggers + persistent deletion log.
  * Retry cleanups on transient object store isues.
  * Fix issue with zombie files on UPSERTs.
* Decouple record APIs form underlying TABLE/VIEW schemas.
* Fix leaky abstractions by pushing tracing initialization into server
  initialization and more strictly separate from logging.
* Update dependencies.

## v0.8.4

* Add a `?loginMessage=` query parameter to admin login page.
* Move query construction for more complex queries to askama templates and add more tests.
* Move subscription-access query construction from hook-time to RecordApi build-time.
* Use askama for auth UI.

## v0.8.3

* Support more SQL constructs:
  * Conflict clause in table and column unique constraints.
  * FK triggers in column constraints.
  * CHECK table constraints.
* Fix: pagination cursors in list queries for arbitrary PKs.
* Sanitize expand and order column names in list queries.
* Update dependencies.

## v0.8.2

* Quote table/index/column names during "CREATE TABLE/INDEX" parsing and construction.
* Improve auth UI: more consistent shadcn styling and explicit tab orders.
* UUID decode sqlite extension and more consistent extension names.
* Update deps.

## v0.8.1

* Derive job id in native code for JS/TS jobs.
* Fix conflict resolution selector in admin UI's API settings.
* Fix primary key card collapsing in create table form.

## v0.8.0

* Add support for periodic cron jobs:
  * Add dashboard to admin UI to inspect, configure and trigger cron jobs.
  * Users can register their own cron jobs from the JS runtime.
  * Replace internal periodic tasks with cron jobs to increase configurability,
    discoverabilty, and avoid drift.
  * BREAKING: removed `backup_interval_sec` from proto config. When explicitly specified,
    users will need to remove it from their `<traildepot>/config.textproto` and set an
    appropriate cron schedule instead.

## v0.7.3

* Cleanup logs DB schema and log ids of authenticated users.
* Allow setting the name and INTEGER type for PKs in create table form.
* Fix reactivity for FK settings in create/alter table forms.
* Add confirmation dialog for user deletions.
* Limit mutations in `--demo` mode.
  * Dedicated admin delete user endpoint.
* Unified parameter building for listing records, users and logs.
* Cleanup backend auth code and query API.
* Update dependencies including rusqlite.

## v0.7.2

* Fix and test OpenId Connect (OIDC) integration.
* Audit and remove unwraps.
* Fix auth img-src CSP for external avatars and dev instances.

## v0.7.1

* Add generic OIDC provider. Can currently only be configured in config. Admin UI integration pending.
* Add --demo mode to protect PII in demo setup.
* Improve secrets redaction/merging.

## v0.7.0

* Schema-aware auto-completion in SQL editor.
* Allow UUID text-encoded 16byte blobs as record ids and in filters during record listing.
* Redact secrets in admin APIs/UI to reduce surface for potential leaks.
* Polish auth/admin UI with image assets for external auth providers like discord, gitlab, ... .
* Permissive `img-src` CSP in auth UI to allow displaying avatars from external auth providers.

## v0.6.8

* Fix client-side merging of fetch arguments including credentials.
* Improved auth UI styling.

## v0.6.7

* Improve token life cycle for JS/TS clients including admin dash.

## v0.6.6

* Add a dialog to avoid accidentally discarding unsaved changes in the SQL editor.
* Polish UI: animate buttons, consistent refresh, avoid logs timestamp overflow.
* Update Rust and JS deps.

## v0.6.5

* Fix routing issues with auth UI.
* Redirect /login to /profile on already logged in.
* Redirect /register to /login?alert= on success.
* Persist execution result in Admin SQL editor.
* Address linter issues.
* Update dependencies.

## v0.6.4

* Add undo history to query editor and improve error handling.
* Cosmetic improvements of Admin UI like more consistency, more accessible buttons, ...
* Indicate foreign keys in table headers.
* Turn table into a route parameter and simplify state management.
* Fix hidden table UI inconsistency.
* Fix input validation issues in form UI.
* Limit cell height in Table UI.

## v0.6.3

* Allow downloading JSON schemas from the UI for all modes: Insert, Update, Select.
* Add some more UI polish: tooltips, optics, and tweaks.
* Improve UI type-safety

## v0.6.2

* Update to address broken vite-plugin-solid: https://github.com/solidjs/vite-plugin-solid/pull/195.

## v0.6.1

* Fix config handling in the UI.
* Improve form handling in the UI.
* Few minor UI fixes & cleanups.
* Update dependencies.

## v0.6.0

* Support foreign record expansion. If a record API is configured allow
  expansion of specific foreign key columns, clients can request to expand the
  parent record into the JSON response of RecordApi `read` and `list`. This is
  also reflected in the JSON schema and warrants a major version update.
  Updates to all the client packages have already been pushed out.
* Support for bulk record creation. This is particularly useful when
  transactional consistency is advisable, e.g. creating a large set of M:N
  dependencies.
* Record subscriptions now have to be explicitly enabled in the
  admin-UI/configuration
* Simplify PNPM workspace setup, i.e. get rid of nesting.
* Fixed rustc_tools_util upstream, thus drop vendored version.
* Reduce logs noise.
* Update dependencies.

## v0.5.5

* Fix build metadata release channel and include compiler version.
* Admin UI: Avoid triggering table's onClick action on text selection.
* Update deps.

## v0.5.4

* Add a `?count=true` query parameter to RecordApi.list to fetch the total
  number of entries.
* Return error on invalid list queries rather than skipping over them.
* Address Admin UI issues:
 * Stale config after altering schema or dropping table.
 * Out-of-sync filter bar value.
 * Reset filter when switching tables.
* Hide "sqlite_" internal tables in Admin UI.

## v0.5.3

* Built-in TLS support.
* Add "server info" to the admin dashboard, e.g. including build commit hash.
* Update deps.

## v0.5.2

* Add file-system APIs to JS/TS runtime to facility accessing resources, e.g.
  templates for SSR (see example/colab-clicker-ssr).
* Add a timeout to graceful shutdown to deal with long-lived streaming connections.
* Allow short-cutting above timeout by pressing a Ctrl+C second time.

## v0.5.1

* Update SQLite from 3.46.1 to 3.48.0.

## v0.5.0

* Breaking change: RecordApi.list now nests records in a parent structure to
  include cursor now and be extensible for the future.
* Update all the client libraries to expect a ListResponse.

## v0.4.1

Minor update:

* Fix issue with delete table potentially invalidating config due to stale RecordAPI entries.
* Update dependencies.

## v0.4.0

Added an early version of Record change subscriptions, a.k.a. realtime, APIs.
Users can now subscribe to an entire API/table or specific record to listen for
changes: insertions, updates, deletions (see client tests, docs are TBD).

## v0.3.4

* Update Axum major version to v0.8.
* Major overhaul of project structure to allow for releasing crates.

## v0.3.3

* Pre-built Windows binary.

## v0.3.2

* Move record API access query construction to RecordApi construction time.
* Cache auth queries
* Some tweaks and hooks API for trailbase_sqlite::Connection.
* Remove sqlite-loadable and replace with rusqlite functions.
* Reduce allocations.

## v0.3.1

* Fix client-ip logging.
* Wire request-type into logs

## v0.3.0

A foundational overhaul of SQLite's integration and orchestration. This will
unlock more features in the future and already improves performance.
Write performance roughly doubled and read latencies are are down by about two
thirds to sub-milliseconds 🏃:

* Replaced the libsql rust bindings with rusqlite and the libsql fork of SQLite
  with vanilla SQLite.
 * The bindings specifically are sub-par as witnessed by libsql-server itself
   using a forked rusqlite.
 * Besides some missing APIs like `update_hooks`, which we require for realtime
   APIs in the future, the implemented execution model is not ideal for
   high-concurrency.
 * The libsql fork is also slowly getting more and more outdated missing out on
   recent SQLite development.
 * The idea of a more inclusive SQLite is great but the manifesto hasn't yet
   manifested itself. It seems the owners are currently focused on
   libsql-server and another fork called limbo. Time will tell, we can always
   revisit.

Other breaking changes:

* Removed Query APIs in favor of JS/TS APIs, which were added in v0.2. The JS
  runtime is a lot more versatile and provides general I/O. Moreover, query APIs
  weren't very integrated yet, for one they were missing an Admin UI. We would
  rather spent the effort on realtime APIs instead.
  If you have an existing configuration, you need to strip the `query_apis`
  top-level field to satisfy the textproto parser. We could have left the
  field as deprecated but since there aren't any users yet, might as well...

Other changes:

* Replaced libsql's vector search with sqlite-vec.
* Reduced logging overhead.

## v0.2.6

* Type JSON more strictly.
* Fix input validation for nullable columns in the insert/edit row Admin UI form.

## v0.2.5

* Addresses issues reported by reddit user *qwacko* 🙏
  * Fix serialization of foreign key column options.
  * Fix deserialization of TableIndex.
  * Admin UI: Show all tables, including hidden ones, in create-table-form's
    drop down for column foreign-keys.

## v0.2.4

* Allow configuring S3 compatible storage backend for file uploads.

## v0.2.3

* Interleaving of multiple HTTP requests into busy v8 isolates/workers.
* JS runtime:
  *  add `addPeriodicCallback` function to register periodic tasks that
     executes on a single worker/isolate.
  *  Constrain method TS argument type (`MethodType`).

## v0.2.2

* Enable "web" APIs in JS runtime.
* Add "Facebook" and "Microsoft" OAuth providers.

## v0.2.1

* Allow setting the number V8 isolates (i.e. JS runtime threads) via
  `--js-runtime-threads`.

## v0.2.0

* Add JS/ES6/TS scripting support based on speedy V8-engine and rustyscript runtime.
  * Enables the registration of custom HTML end-points
  * Provides database access.
  * In the future we'd like to add more life-cycles (e.g. scheduled
    operations).
  * In our [micro-benchmarks](https://trailbase.io/reference/benchmarks/) V8
    was about 45x faster than goja.
* Added official C#/.NET client. Can be used with MAUI for cross-platform
  mobile and desktop development.

## v0.1.1

* Changed license to OSI-approved weak-copyleft OSL-3.0.
* Add GitHub action workflow to automatically build and publish binary releases
  for Linux adm64 as well as MacOS intel and apple arm silicone.
* Add support for geoip database to map client-ips to countries and draw a world map.

## v0.1.0

* Initial release.
