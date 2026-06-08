# Bedrock 3.8.9 Release Notes

**Release Date:** 2026-06-08

## Overview

3.8.9 is a maintenance and hardening release focused on correctness fixes
across the `Model` subsystem, a long-standing `OPTIONS_EXPR` regex bug that
caused leading whitespace to be included in captured option text, a defensive
fix in `DBI::Locator`, and a substantial expansion of the test suite.  A new
`RecordSet` module and a `release-notes` build target round out the release.

---

## Bug Fixes

### `Bedrock::Constants` - `OPTIONS_EXPR` leading-whitespace fix

`$OPTIONS_EXPR` was not anchoring past the leading whitespace before the first
capture group, so `$1` (the options text) always included the space that
follows the opening `<tag`.  The regex now opens with `^\s*` so the captured
options text is properly trimmed.

```
# before
Readonly our $OPTIONS_EXPR => '^(([^>\\\\]|\\\\.)*?)\\s*((?:-\\/|\\/-|\\/|-)?)>';

# after
Readonly our $OPTIONS_EXPR => '^\\s*(([^>\\\\]|\\\\.)*?)\\s*((?:-\\/|\\/-|\\/|-)?)>';
```

### `Bedrock::DBI::Locator` - guard against unblessed config ref

`get_from_data_sources` called `$config->can('dbnames')` without first
checking whether `$config` was a blessed reference, which caused a fatal error
when a plain hash ref was passed.  The guard now uses `Scalar::Util::blessed`
before testing `can`.

```perl
# before
my $dbnames = $config->can('dbnames') ? $config->dbnames : {};

# after
my $dbnames = blessed $config && $config->can('dbnames') ? $config->dbnames : {};
```

### `Bedrock::Model::Field` - `DEFAULT_GENERATED` removed from `as_string`

`as_string` was emitting `DEFAULT_GENERATED` in the serialized column
definition, a MySQL 8+ attribute that was introduced prematurely and broke
compatibility with older MySQL versions in some environments.

### `Bedrock::Model::Serializer::MySQL` - backtick-quote table names

`describe_table` now wraps table names in backticks, preventing failures when
table names collide with MySQL reserved words.

---

## Improvements

### `Bedrock::Model` subsystem

- `Model->new`: removed redundant `dry_run` option variations; `dbi` and
  `model` are now passed explicitly to `verify_model` for cleaner dependency
  injection.
- `Model::Field->new`: `ignore_unknown_keys` now defaults to `true`, reducing
  noise from schema drift during development.
- `Model::Migration->new`: same `ignore_unknown_keys` default applied.
- `Model::Migration->migrate` / `->execute`: minor refactoring throughout;
  `croak` is now used consistently instead of bare `die`, giving callers
  proper stack context.  Key information is now collected during migration for
  future use.
- `Model::Handler->migration` / `Model::Role->_verify_model`: argument
  pass-through corrected so downstream methods receive the full argument list.
- Logging added to `Model::Field` and `Model::Migration` for improved
  visibility during schema operations.

### `Bedrock::DBI::Locator` - POD added

Complete POD documentation added covering the module's credential-resolution
strategy, all public methods, configuration sources (environment variables,
`data-sources.xml`, config object), and usage examples.

### `Bedrock::Role::DocFinder`

`is_available_on_metacpan` cleaned up: stray debug statement removed, minor
internal refactoring.

### DarkPAN repo index template

- Fixed script name typo: `orepan2-s2>` → `orepan2-s3`.
- Corrected README extraction description: `README.html` → `README.md`.
- Fixed distribution list sort: `repo.sort` → `repo.keys.sort` so the
  template correctly iterates hash keys.

---

## New Modules

### `Bedrock::RecordSet`

New module providing a lightweight result-set wrapper for query results,
consistent with the `Model` subsystem's data-handling conventions.

---

## Build System

### `release-notes.mk` - new makefile include

Adds a `release-notes` phony target that automates production of the three
release artifacts (`release-VERSION.diffs`, `release-VERSION.lst`,
`release-VERSION.tar.gz`) by diffing against the previous git tag.  Supports
an optional `LAST_TAG` environment variable override.

### `Makefile.am` - `cpan` target added

A new `cpan` phony target automates the full CPAN distribution build sequence:
clean build, `bedrock-core` CPAN package, top-level CPAN package, and
`release-notes` generation.  `clean-local` now also removes release artifact
files.

---

## Test Suite Additions

Six new test files were added, significantly expanding automated coverage:

| Test file | What it covers |
|---|---|
| `t/00-tagx_options_expr_suffix.t` | `OPTIONS_EXPR` suffix parsing: all suffix variants (`>`, `->`, `/>`, `-/>`), escaped content edge cases, and the `/->`-is-invalid rejection path |
| `t/00-doc-finder.t` | `Bedrock::Role::DocFinder` unit tests |
| `t/00-view-source.t` | View-source handler baseline tests |
| `t/01-view-source.t` | View-source handler extended tests |
| `t/autocomplete.t` | `Apache::BedrockAutocomplete` handler: content-type header, JSON payload shape, label/value keys, multi-result queries, and `BEDROCK_AUTOCOMPLETE_ROOT` global fallback |
| `t/regexp_baseline.t` | `Bedrock::RegExp`: basic capture, escaped delimiters, named captures, numeric captures, `regexp_evaluate` in scalar context |
| `t/regexp_baseline_hardened.t` | `Bedrock::RegExp` edge cases: complex path regexes with escaped slashes, branch-reset group numbering, multiline flag compilation |
