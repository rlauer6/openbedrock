# Bedrock 3.8.7 Release Notes

**Release Date:** March 12, 2026

---

## YAML Dependency Consolidation

Bedrock has standardized on `YAML::XS` as its sole YAML library.
`YAML` (aka YAML::Old) and `YAML::Tiny` have been removed from all
production and test dependency lists.

Every file that previously imported `YAML` or `YAML::Tiny` now
imports `YAML::XS`. The stale `$YAML::UseBlock = 1` directive in
`Bedrock::Serializer::YAML` has been removed — `YAML::XS` defaults
to block style, so the behavior is unchanged.

The `fetch_config()` deserialization pipeline in
`Bedrock::BedrockConfig` now checks `ref $config` instead of just
truthiness, preventing `YAML::XS` from silently swallowing non-config
input (bare scalars that YAML::XS parses without error).

### Files changed

`BedrockConfig.pm`, `Hash.pm`, `LoadConfig.pm`, `Role::Config`,
`Serializer::YAML`, `Service.pm`, `Test.pm`,
`bedrock-miniserver.pl`, `dnky-config.pl`, and test files
(`00-blm-startup-config.t`, `00-config.t`, `00-handler.t`).

---

## `List::Util` Version Pinned to 1.56

The CPAN dependency for `List::Util` is now pinned to `>= 1.56` in
`bedrock-core/requires`. This is required for `mesh`, which was added
in that version (shipped with Perl 5.036). Without the pin, CPAN
would skip the upgrade on older Perls since `List::Util` is a core
module, causing import failures at runtime.

---

## New: `evolve()` and `clone()` in Serializer, Array, and Hash

`Bedrock::Serializer` now exports three functions: `devolve`,
`evolve`, and `clone`.

`devolve()` was refactored to use `Scalar::Util::reftype` for type
detection. It now handles any blessed hashref or arrayref
generically, and gracefully returns non-ref values and `undef`
instead of dying on unrecognized references.

`evolve()` recursively blesses plain hashrefs and arrayrefs as
`Bedrock::Hash` and `Bedrock::Array` in place (no copy). Already-
blessed objects are left untouched. JSON boolean objects are
converted to `0`/`1`.

`clone()` does the same promotion but creates new `Bedrock::Hash`
and `Bedrock::Array` copies instead of blessing in place, leaving
the original data structure unmodified. This is critical for the
miniserver's ServerStatus service, which previously blessed shared
runtime config objects and caused circular reference issues.

Both `Bedrock::Array` and `Bedrock::Hash` now delegate `devolve()`
to `Bedrock::Serializer::devolve` and expose new `evolve()` and
`clone()` instance methods. The duplicate `devolve` implementations
that lived in Array.pm and Hash.pm have been removed.

New test file: `t/00-serializer.t`.

---

## New: `promote_object()`

`Bedrock.pm` exports a new utility function `promote_object()` that
promotes a single plain hashref or arrayref to its Bedrock equivalent
(`Bedrock::Hash` or `Bedrock::Array`). Already-blessed objects and
non-references pass through unchanged. This is used by the
`<foreach>` tag to ensure hash values are accessible as Bedrock
objects during iteration.

---

## `<foreach>` Improvements

### Hash Value Promotion

When iterating over a hash, values that are plain hashrefs or
arrayrefs are now promoted to `Bedrock::Hash` / `Bedrock::Array` via
`promote_object()`. Previously, nested structures were passed as
unblessed references and Bedrock method calls on them would fail.

### Default Counter and Index Variable Names

`--define-counter` now defaults to `_counter` and `--define-index`
defaults to `_index`. Previously these were `undef`, meaning no
counter or index variable was created unless explicitly requested.
Templates can now reference `$_counter` and `$_index` without extra
options:

```
<foreach $array><var $_index>: <var $_></foreach>
```

### POD Overhaul

The `<foreach>` documentation has been substantially rewritten with
clearer explanations of `--start-index` vs `--counter-start`,
improved hash iteration examples, and corrected formatting of
recordset iteration code samples.

### New Hash Iteration Tests

`t/18-hash.yml` adds five new tests covering hash iteration with
`<foreach>`: named variables, anonymous `$_` access, counter-start,
start-index, and the new default `$_index`.

---

## Miniserver Enhancements

### Directory Index Resolution

Directory index handling has been moved from a static alias-expansion
pass at startup to a proper runtime resolver
(`_resolve_directory_index()`). This runs before alias resolution in
the request pipeline, matching the longest-prefix `directory_index`
entry and trying each candidate file in order. This fixes cases
where the old alias approach would shadow other routes or fail to
resolve nested directory paths.

### Zero-Config Quick Start

Running `bedrock-miniserver.pl` with no arguments and no config file
now bootstraps a working environment: it creates an `html/` document
root with a default `index.roc`, writes a
`bedrock-miniserver.yml` configuration file to the current directory,
and starts serving. The POD has been updated with a new "Start a New
Application" section documenting this workflow.

### `cmd_config` Command

New `config` command for inspecting the resolved miniserver
configuration.

### Circular Reference Prevention

`_serve_static()` no longer copies all keys from `global_config` into
`tagx_config`, which could introduce circular references. Instead, a
`server_config_lite` hash is constructed with only the keys needed by
templates (`aliases`, `routes`, `env`, `log_level`, `port`, etc.).
The same selected-key pattern is applied in `_mount_service()` when
passing server config to service instances.

### Service Registry

Services now receive a finalized `registry` object (a hash mapping
mount points to class names) after all services are mounted. The
`Bedrock::Service` base class has a new `registry` accessor.
Previously the registry was passed during construction — before all
services were mounted — leading to incomplete registry data.

### YAML::Tiny => YAML::XS

Both the main miniserver package and the CLI helper now use
`YAML::XS` instead of `YAML::Tiny`.

---

## Server Status Page Redesigned

`server-status.roc` has been completely rebuilt with a dark-themed UI
using IBM Plex Mono/Sans, CSS custom properties, and collapsible
sections. The page now shows port, log level, directory index
configuration, and a running/uptime indicator pill. A new
`bedrock-dino.png` mascot image is included in the distribution.

The `ServerStatus` service was refactored to use `Bedrock::Hash->new`
(cloning) instead of `bless` on shared config objects, eliminating
circular reference warnings in template rendering.

---

## Bug Fixes

### `Bedrock.pm` `@INC` Fix

The `BEGIN` block that adds Bedrock distribution paths to `@INC`
was incorrectly skipping paths that should have been added and
adding paths that didn't exist. The check now uses a regex match
against existing `@INC` entries and validates directory existence
before prepending.

### `BedrockConfig::merge` Error Message

The error message for invalid configuration root objects now includes
the value that was received, aiding debugging when `YAML::XS` returns
a bare scalar from a malformed config file.

### `Hash.pm` VERSION Typo

`$VERSION` was set from `@PACKAG_VERSION@` (missing E). Corrected to
`@PACKAGE_VERSION@`.

### `HandlerUtils.pm` POD

Fixed unclosed `C<>` formatting code in `validate_session`
documentation.

---

## Code Cleanup

- **`Hash.pm`**: removed `use YAML qw(Dump)` from inside the
  `yaml()` method body (now imported at the top of the file)
- **`ServerStatus.pm`**: removed dead `xaction_index()` method
- **`00-hash.t`**: whitespace normalization, removed empty POD block
- **`00-upload.t`**: removed stray `diag(Dumper(...))` diagnostic
- **`00-config.t`**: improved diagnostics on JSON round-trip test
  failures
- **`release` script**: replaced `make clean && make` with targeted
  `rm -f *.tar.gz` before build to avoid unnecessary rebuilds

---

## Build and Packaging

- `YAML::XS` replaces `YAML` in `cpan/bedrock-core/requires` and
  `cpan/requires`
- `YAML::XS` replaces `YAML` in `cpan/test-requires`
- `YAML` removed from `cpan/requires`
- `List::Util` pinned to `1.56` in `cpan/bedrock-core/requires`
- `bedrock-dino.png` added to `img/Makefile.am`
- `t/00-serializer.t` added to `lib/Makefile.am`
