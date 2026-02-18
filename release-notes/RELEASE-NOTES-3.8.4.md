# Bedrock 3.8.4 Release Notes

**Release Date:** February 18, 2026

---

## Major: Test Harness Refactored for Per-Group Configuration

The `bedrock-test.pl` harness has been substantially refactored to
support independent test groups, each with their own configuration
overrides, environment variables, and lifecycle scripts. This is the
centerpiece of 3.8.4.

### Test Groups with Isolated Configuration

Groups defined in the YAML configuration file can now specify their
own `config`, `env`, `setup`, and `teardown` sections. The harness
runs each group in isolation using `local %ENV`, and configuration
overrides are delivered to child processes via Bedrock's existing
`BEDROCK_CONFIG_PATH` XML overlay mechanism — no changes to the
runner or engine were required.

```
groups:
  sql:
    setup:
      exe: start-mysql.sh
    env:
      DBI_SOCKET: /tmp/mysqld/mysqld.sock
      DBI_USER: fred
      DBI_PASS: flintstone
    teardown: |
      docker stop $(cat mysql-docker.id)
    tests:
      - t/12-sqlconnect.yml
      - t/13-sql.yml
```

Root-level `env` values merge into every group (group values win).
Root-level `config` overrides are applied to all groups, with
group-level overrides taking highest precedence.

### Three Levels of Plugin Configuration

Application plugins (`BLM::Startup::*`) can now be configured at
three levels, each composing with the others:

- **Root-level** — `config: MODULES:` in the harness YAML, inherited
  by all groups
- **Per-group** — under `groups: <name>: config: MODULES:`, shared by
  all tests in that group
- **Per-test** — `config: MODULES:` inside the individual `.yml` test
  file

This eliminates the need to duplicate MODULES declarations across
test files or groups.

### External Script Support (`exe:` key)

Setup and teardown scripts can now reference external files instead
of inline heredocs:

```
setup:
  exe: t/setup/start-mysql.sh
```

The harness validates that the file exists and is executable. Inline
scripts still work and default to `/bin/sh` if no shebang is present.

### Config File Now Optional

The harness can now run without a `--config-file` argument. This
supports the simplest invocation pattern:

```
bedrock-test.pl run t/00-foo.yml
```

### New Subroutines and Refactoring

- `_cmd_run_get_test_defs()` — replaces `_cmd_run_get_tests()`;
  returns a hash of group definitions instead of a flat file list
- `_init_test_def()` — constructs a normalized test definition for a
  single group
- `_run_script()` — lightweight script executor (extracted from
  `cmd_run`)
- `_cmd_run_script()` — script preparation: writes inline scripts to
  temp files, validates `exe:` paths, handles shebang injection
- `END` block extended to clean up temp files via `@CLEANUP_FILES`

---

## Bug Fixes

### Cache::Shareable scalar serialization

`Bedrock::Cache::Shareable` now correctly serializes and
deserializes plain scalars. Previously, `set()` passed scalars
directly to `Storable::nfreeze`, which requires a reference.
Scalars are now wrapped in a reference before freezing and
dereferenced after thawing. The `touch()` method applies the same
fix.

### Chomp options were backwards in Bedrock::Test

The `chomp` option in test YAML files had `front` and `end`
behavior swapped. `front` was removing trailing newlines and `end`
was removing leading newlines. These are now corrected.

### Bedrock::Test creates fresh config per test

`Bedrock::Test::run()` previously shared a single config object
across all tests in a file. Config overrides from one test would
leak into subsequent tests. Each test now gets its own config copy
via `init_local_config()`.

### Bootstrap benchmark initialization

`Bedrock::Bootstrap::log_benchmark()` now sets the initial benchmark
timestamp if one hasn't been set, preventing warnings on the first
call.

---

## New Utilities

### `bedrock-cache.pl` `destroy` command

`bedrock-cache.pl` now supports a `destroy` (aliased as `-d`)
command for tearing down shared memory cache segments. Previously
this required manual IPC cleanup. The script also now uses Bedrock
constants throughout.

### `bedrock-plugin.pl` refactored

The plugin scaffolding tool has been refactored and now always
produces a tarball output.

### `Bedrock::Service::CLI` `new` command

`Bedrock::Service::CLI` now supports a `new` command for
scaffolding new services from the command line.

---

## Documentation Updates

- **`bedrock-test.pl`**: comprehensive POD rewrite covering options,
  commands, and the full test configuration file format including
  groups, `config`, `env`, `setup`/`teardown`, and `exe:`
- **`bedrock-runner.pl`**: POD updates, default `config_path` now
  reads from `$ENV{BEDROCK_CONFIG_PATH}`, calls
  `Bedrock::Test::finalize` instead of `done_testing`
- **`bedrock-miniserver.pl`**: added Quick Start section to POD
- **`BLM::Plugin`**: POD updates
- **`Bedrock::Application::Plugin`**: error message wording changes,
  `find_plugin_config()` refactored, POD tweaks
- **`Bedrock::Plugin`**: POD tweak, whitespace cleanup
- **`<null>` tag**: POD updated for `--sleep` option
- **`Bedrock::Cache::Shareable`**: removed duplicate `=head` section

---

## Schema and Configuration

### `miniserver-schema.json`

The `module` field is no longer required in the miniserver JSON
schema, allowing simpler route configurations.

### `directory-index`

New `directory-index` file added to the Bedrock htdocs distribution.

---

## Test Infrastructure

- **`start-mysql.sh`**: new helper script for Docker-based MySQL
  test environments. Includes `wait_for_mysql()` polling function,
  daemonizes the container, and writes the container ID for teardown.
- **`t/12-sqlconnect.yml`**: added socket path support
- **`t/21-sqlselect.yml`**: updated regex for more precise matching
- **`t/13-sql.yml`**: whitespace cleanup

---

## Code Cleanup

- `Bedrock::Model::Maker`: removed stray `Carp::Always` import
