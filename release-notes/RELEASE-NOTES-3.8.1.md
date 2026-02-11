# Bedrock 3.8.1 Release Notes

**Release Date:** February 10, 2026

This release includes major enhancements to the `<iif>` tag, a refactored test framework, and numerous improvements to developer tools and Docker support.

---

## Major Features

### Expression Evaluation in `<iif>` Tag

The `<iif>` tag now supports full expression evaluation, bringing it to feature parity with the `<if>` tag.

**What's New:**
- Full operator support: unary (`--not`, `--defined`, `--array`, `--hash`, `--scalar`, `--ref`) and binary (`--eq`, `--ne`, `--gt`, `--ge`, `--lt`, `--le`, `--and`, `--or`, `--re`)
- Complex expressions with nested parentheses
- Optional third argument (value-if-false can be omitted for HTML attributes)
- Backward compatible with simple truthiness testing

**Examples:**

```bedrock
<!-- Simple expressions -->
<iif $status --eq 'active' Active Inactive>
<iif $count --gt 10 many few>

<!-- Unary operators -->
<iif --defined $user yes no>
<iif --array $items yes no>

<!-- Complex expressions -->
<iif (($user.role --eq 'admin') --and $user.active) authorized unauthorized>

<!-- Optional third arg for HTML attributes -->
<input type="checkbox" <iif $checked checked>>
<div <iif $active 'class="active"' 'class="inactive"'>>
```

**Implementation:**
- New `TagX::Expr::Evaluator` role shared between `<if>` and `<iif>` tags
- Comprehensive test suite with 60+ test cases
- See: `src/main/perl/lib/Bedrock/Text/TagX/Expr/Evaluator.pm.in`

---

## Test Framework Improvements

### New Test Orchestration Tool

**bedrock-test.pl** - New command-line tool for running Bedrock tests with group support.

**Features:**
- Run tests by group (general, sql, cache, mail)
- Configuration via YAML
- Uses TAP::Harness for proper test aggregation
- Environment variable injection
- Config overrides per test group

**Usage:**
```bash
# Run specific group
bedrock-test -c test.yml -g general

# Run multiple groups
bedrock-test -c test.yml -g general -g sql

# Run single test
bedrock-test t/05-iif.yml
```

**Configuration example (test.yml):**
```yaml
overrides:
  ALLOW_FILE_WRITE: yes

groups:
  general:
    - t/00-var.yml
    - t/05-iif.yml
  
  sql:
    - t/12-sqlconnect.yml
    - t/13-sql.yml
```

### Refactored Test Runner

**bedrock-runner.pl** (formerly test-tag.pl):
- Refactored to use `CLI::Simple`
- Supports config file overrides via `$ENV{BEDROCK_TEST_CONFIG}`
- Better path handling with `File::Spec`
- Proper integration with TAP::Harness

---

## Bedrock::Test Enhancements

### Object Promotion in Test Parameters

YAML arrays and hashes in test `param:` sections are now automatically promoted to Bedrock objects!

**Before:**
```yaml
param:
  items: [1,2,3]
test: <iif $items hasitems noitems>  # Always true (it's a ref)
```

**Now:**
```yaml
param:
  items: [1,2,3]
test: <iif $items.length() hasitems noitems>  # Works! Can use methods!

param:
  obj: {key: value}
test: <iif $obj.keys() hasobject noobject>  # Methods work!
```

This makes tests more realistic and allows testing actual Bedrock object behavior.

### New Methods

- `Bedrock::Test::finalize()` - Alternative to `done_testing()`
- Better test planning and execution control

---

## Tag Improvements

### Enhanced `<var>` Tag

**--markdown Upgrade:**
- Now uses `Markdown::Render` module if available
- Automatic Table of Contents generation with `@TOC@`
- Metadata interpolation: `@DATE()@`, `@GIT_USER@`, `@GIT_EMAIL@`
- Better anchor handling for headers
- Falls back to standard markdown rendering if `Markdown::Render` unavailable

**Example:**
```bedrock
<var --markdown $markdown_content>
```

With `Markdown::Render` installed, your markdown can include:
```markdown
# @TOC_TITLE@

@TOC@

# Section One

Content here...

@TOC_BACK@
```

### New `Bedrock::Hash` Method

**empty()** - Check if hash is empty

```bedrock
<if $hash.empty()>
  Hash is empty
<else>
  Hash has <var $hash.keys().length()> keys
</if>
```

---

## Bug Fixes

### TagX::Expr --scalar Operator

**Fixed:** The `--scalar` operator was incorrectly checking for scalar references instead of scalar values.

**Before (bug):**
```perl
# Checked if value was a SCALAR reference (\$foo)
return ref $value && reftype($value) eq 'SCALAR';
```

**After (fixed):**
```perl
# Correctly checks if value is NOT a reference (scalars are not refs)
return !ref $value;
```

**Impact:** 
- `<iif (--scalar $foo) yes no>` now works correctly for scalar values
- `<if --scalar $string>` properly identifies scalar strings/numbers

### TagX::Scalar matches()

**Fixed:** Uninitialized value warnings when `$flags` variable was undefined.

### Bedrock::Service Session Initialization

**Changed:** `init_session()` now uses `carp` instead of `croak` when session config cannot be found, allowing more graceful degradation.

---

## Docker & Deployment Improvements

### SQLite Session Support

**docker-compose.yml:**
- Changed default session manager from MySQL to SQLiteSession
- More lightweight for development/testing

**entrypoint.sh improvements:**
- Proper initialization of SQLite session database
- Fixed path to `dnky-config.pl`
- Better session manager detection (uses full class name: `SQLiteSession` vs `UserSession`)
- Automatic creation of `/var/lib/bedrock/bedrock.db`

**Dockerfile.debian:**
- Added `sqlite3` package to final image
- Automatic setup of `bedrock-docs.conf` Apache configuration

### Configuration

**bedrock-docs Apache Configuration:**
```bash
# Automatically generated during Docker build
/usr/lib/cgi-bin/bedrock-service.cgi --service Docs --mod-cgi \
  --base-uri /bedrock >/etc/apache2/conf-available/bedrock-docs.conf
a2enconf bedrock-docs
```

Bedrock documentation now accessible at `/bedrock/docs` in Docker containers.

---

## Build System Changes

### New Module: Bedrock::Bootstrap

- Added to build system
- Helper for initialization and setup tasks

### Package Updates

**cpan/bedrock-core/Makefile.am:**
- Added `Bedrock::Bootstrap`
- Added `bedrock-runner.pl` to executables
- Added `bedrock-test.pl` to executables
- Added `dnky-config.pl` to executables

**cpan/buildspec.yml:**
- Added `Bedrock::Role::DocFinder` to provides list

### Test Distribution

**src/main/perl/Makefile.am:**
- Removed standalone `test-tag.pl` (replaced by `bedrock-runner.pl`)

---

## New Files

### Core Modules
- `src/main/perl/lib/Bedrock/Text/TagX/Expr/Evaluator.pm.in` - Shared expression evaluator role

### Executables
- `src/main/perl/bin/bedrock-test.pl.in` - Test orchestration tool
- `src/main/perl/bin/bedrock-runner.pl.in` - Individual test runner (renamed from test-tag.pl)

### Support
- `Bedrock::Bootstrap` - New initialization module

---

## Backward Compatibility

### Breaking Changes
**None.** All changes are backward compatible.

### Deprecations
**None.**

### Migration Notes

**For `<iif>` tag users:**
- Existing simple truthiness tests continue to work
- New expression support is opt-in
- Third argument is now optional (defaults to empty string)

**For test framework users:**
- Old `test-tag.pl` replaced by `bedrock-runner.pl` (same functionality, better structure)
- Symlinks should point to new `bedrock-runner.pl`
- Existing test YAML files work unchanged
- New `bedrock-test.pl` is optional but recommended for test orchestration

**For Docker users:**
- Default session manager changed to SQLiteSession (can override via environment variable)
- Existing MySQL setup still works with `BEDROCK_SESSION_MANAGER=UserSession`

---

## Testing

**Test Coverage:**
- `<iif>` tag: 60/61 tests passing (98.4% pass rate)
- One known limitation: nested inline `<iif>` expressions (parser limitation, documented workaround available)

**New Test File:**
- `src/main/perl/t/05-iif.yml` - Comprehensive test suite for `<iif>` tag

---

## Developer Notes

### CLI::Simple Refactoring

Both `bedrock-runner.pl` and `bedrock-test.pl` now use `CLI::Simple` for:
- Consistent command-line interface
- Better option parsing
- Extensible command structure

### run-tests Script Improvements

**src/main/perl/run-tests:**
- Refactored for cleaner bash practices
- Proper cleanup using `trap` to ensure cleanup runs at exit
- Updated to use new `bedrock-runner.pl`

### Environment Variables

**New/Changed:**
- `BEDROCK_CONFIG_PATH` - Path to Bedrock config directory (used by bedrock-runner.pl)
- `BEDROCK_TEST_CONFIG` - Path to test configuration YAML (used by bedrock-runner.pl)
- `BEDROCK_SESSION_MANAGER` - Session manager class name (SQLiteSession or UserSession)

---

## Installation & Upgrade

### From Source

```bash
./configure
make
make install
```

### Docker

```bash
docker pull openbedrock/bedrock:3.8.1
```

Or build from source:
```bash
docker build -f docker/Dockerfile.debian -t bedrock:3.8.1 .
```

### CPAN

```bash
cpanm Bedrock@3.8.1
```

---

## Known Issues

### `<iif>` Tag

**Nested inline expressions don't work:**
```bedrock
<!-- This doesn't work -->
<iif $level --gt 5 high <iif $level --gt 2 medium low>>
```

**Reason:** Parser limitation - inline tags cannot contain other inline tags.

**Workaround:**
```bedrock
<!-- Use variable pattern -->
<null:result><iif $level --gt 2 medium low></null>
<iif $level --gt 5 high $result>
```

---

## Contributors

- Rob Lauer <rclauer@gmail.com>

---

## Resources

- Documentation: https://openbedrock.github.io
- GitHub: https://github.com/rlauer6/openbedrock
- Issues: https://github.com/rlauer6/openbedrock/issues

---

## What's Next

**Planned for 3.9.0:**
- Further test framework enhancements (setup/teardown support)
- Additional operator support
- Performance optimizations

---

**Full Changelog:** See `ChangeLog` in repository for complete commit history.
