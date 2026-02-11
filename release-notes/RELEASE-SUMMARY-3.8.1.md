# Bedrock 3.8.1 - Quick Summary

**Released:** February 10, 2026

## Highlights

**Expression Evaluation in `<iif>` Tag**
- Full operator support (--eq, --gt, --and, --or, --re, and more)
- Optional third argument for cleaner HTML attribute patterns
- 98.4% test pass rate with 60+ comprehensive tests

**New Test Framework**
- `bedrock-test` CLI tool for test orchestration
- YAML-based test groups (general, sql, cache, mail)
- Automatic object promotion in test parameters

**Enhanced Markdown Support**
- `<var --markdown>` now uses Markdown::Render when available
- Automatic TOC generation, metadata interpolation
- Better anchor handling

**Bug Fixes**
- Fixed --scalar operator (was checking for refs instead of scalars)
- Fixed uninitialized warnings in Scalar::matches()
- Better session initialization error handling

**Docker Improvements**
- SQLite session manager as default
- Automatic bedrock-docs configuration
- Better entrypoint initialization

## Examples

### New `<iif>` Capabilities

```bedrock
<!-- Binary operators -->
<iif $status --eq 'active' Active Inactive>

<!-- Complex expressions -->
<iif (($user.role --eq 'admin') --and $user.active) authorized unauthorized>

<!-- HTML attributes (optional 3rd arg) -->
<input type="checkbox" <iif $checked checked>>
```

### Test Object Promotion

```yaml
# Arrays/hashes become Bedrock objects in tests!
param:
  items: [1,2,3]
  obj: {key: value}
test: |
  <iif $items.length() hasitems noitems>
  <iif $obj.keys() hasobject noobject>
```

### New Test Orchestration

```bash
# Run test groups
bedrock-test -c test.yml -g general -g sql

# Configuration
# test.yml:
groups:
  general:
    - t/00-var.yml
    - t/05-iif.yml
  sql:
    - t/12-sqlconnect.yml
```

## Upgrade Notes

**Backward Compatible** - No breaking changes

**If you use Docker:**
- Default session changed to SQLite
- Set `BEDROCK_SESSION_MANAGER=UserSession` to keep MySQL

**If you use test framework:**
- `test-tag.pl` → `bedrock-runner.pl` (same functionality)
- Update symlinks to point to new runner

## Install

```bash
# From source
./configure && make && make install

# Docker
docker pull openbedrock/bedrock:3.8.1

# CPAN
cpanm Bedrock@3.8.1
```

---

**Full release notes:** [RELEASE-NOTES-3.8.1.md](RELEASE-NOTES-3.8.1.md)
