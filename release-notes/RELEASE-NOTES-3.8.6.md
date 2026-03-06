# Bedrock 3.8.6 Release Notes

**Release Date:** March 6, 2026

---

## Major: Session Management Refactored

The session management hierarchy has been restructured so that
`BLM::Startup::BaseSession` provides a complete, working session
implementation while `BLM::Startup::SessionManager` extends it with
login-session support. This eliminates substantial code duplication
between the two modules.

### BaseSession Now Self-Contained

`BaseSession` was previously a thin abstract class with stub
methods. It now contains all of the core session machinery that was
duplicated in `SessionManager`:

- Cookie management (`cookie()`, `send_cookie()`, `bake_cookie()`)
- Session lifecycle (`startSession()`, `newSessionID()`,
  `newSession()`, `init_session()`, `read_data()`)
- Session directory management (`session_root()`,
  `create_session_dir()`, `create_session_file()`,
  `create_session_tempfile()`, `cleanup_session_dir()`)
- Configuration and serialization (`config()`,
  `serialize_session()`, `deserialize_session()`,
  `cookieless_session()`)
- Tied hash interface (`TIEHASH()`, `FETCH()`, `STORE()`,
  `FIRSTKEY()`, `NEXTKEY()`, `EXISTS()`, `DELETE()`, `CLEAR()`,
  `closeBLM()`)
- Logging (`set_log_level()`)

Any custom session manager that subclasses `BaseSession` gets all
of this for free, needing only to implement the five storage stubs:
`CONNECT`, `DISCONNECT`, `FETCH_SESSION`, `STORE_SESSION`, and
`KILL_SESSION`.

### SessionManager Slimmed Down

`SessionManager` now inherits from `BaseSession` via `use parent`
and deletes all of the methods that were promoted to the parent
class. What remains is exclusively login-session logic:
`FETCH_LOGIN_SESSION`, `STORE_LOGIN_SESSION`, `UPDATE_LOGIN_SESSION`,
`REGISTER`, `REMOVE_USER`, `UPDATE_LOGIN_PASSWORD`, `LOGIN`,
`LOGOUT`, plus the higher-level wrappers (`login()`, `logout()`,
`register()`, `remember_user()`, etc.).

The `_fetch_session()` override in `SessionManager` calls
`$self->SUPER::_fetch_session()` first, then falls through to
login-cookie resolution if no anonymous session is found.

### CSRF Moved to BaseSession

The `Bedrock::CSRF` role is now composed into `BaseSession` instead
of `SessionManager`, making CSRF token support available to all
session managers - not just those that support logins.

---

## Security: Cryptographic Session IDs and CSRF Tokens

### `Crypt::URandom` Replaces `Digest::MD5`

Session identifiers and CSRF tokens are now generated using
`Crypt::URandom` instead of `Digest::MD5` seeded with
time/PID/rand. `BaseSession::digest()` now returns 16 bytes (32 hex
characters) of OS-supplied random data, and `CSRF::csrf_token()`
uses 32 bytes (64 hex characters). This eliminates predictability
concerns with the old seed material.

`Crypt::URandom` has been added to the CPAN dependency list.

### CSRF Token Rotation on Check

`check_csrf_token()` now rotates the token immediately after
verification, regardless of whether the check succeeded. This
prevents replay attacks where a stolen token could be reused.

### Cookie Security Defaults

The `cookie()` method in `BaseSession` now sets `HttpOnly` and
`SameSite=Strict` by default. When the request arrives over HTTPS,
the `Secure` flag is also set automatically. The previous
`SameSite=none` default in the old `send_cookie()` has been
replaced.

---

## New: `Bedrock::Iterator` Extracted to Own Module

`Bedrock::Iterator` has been moved from its inline definition inside
`Bedrock::Array` to a standalone file (`Bedrock/Iterator.pm`). The
class is unchanged - `new()`, `next()`, `prev()`, `curr()`,
`begin()`, `end()`, `pos()`, `valid()` - but it now ships as a
proper top-level module in the distribution, the RPM spec, and the
CPAN Makefile.

---

## New: `RecordSet::smart_sort` and `smart_sort_desc`

`Bedrock::RecordSet` now supports multi-field sorting that
automatically detects whether each field is numeric or alphabetic
by inspecting the data.

`smart_sort(@fields)` analyzes the values across all records for
each named field. If every defined value in a column looks numeric,
that column sorts numerically (with missing values filled as `0`);
otherwise it sorts alphabetically (missing values filled as empty
string). Multiple fields are applied in priority order - the first
field is primary, the second breaks ties, and so on.

`smart_sort_desc(@fields)` returns the result in reverse order.

A private helper `_analyze_field()` performs the per-column type
detection using `Scalar::Util::looks_like_number`.

---

## Refactored: `devolve()` in Array and Hash

The `devolve()` method in both `Bedrock::Array` and `Bedrock::Hash`
has been rewritten as a single recursive function based on
`Scalar::Util::reftype`. Instead of checking specifically for
`Bedrock::Array` and `Bedrock::Hash` blessings, it now strips *all*
blessings from any hashref or arrayref encountered during traversal.
This means objects blessed into arbitrary classes (e.g.
`Some::RandomClass`) are also properly devolved to plain data
structures.

The redundant `BEGIN` block in `Bedrock::Array` was removed as part
of this cleanup.

New test coverage in `t/00-array.t` and `t/00-hash.t` validates
deep nesting, mixed types, and arbitrary blessed references.

---

## Bug Fixes

### RecordSet `sort()` asc/desc regex

The order-direction validation regex in `Bedrock::RecordSet::sort()`
was not anchored, so partial matches like `ascending` or `descend`
would have been accepted. The regex is now
`/^(?:asc|desc)$/xsm`.

### `Bedrock::Error` `_render_shell`

`_render_shell()` now calls `slurp_file` in scalar context,
preventing list-context surprises.

### `sqlselect` test regex

`t/21-sqlselect.yml` had an incorrect regex that could match
spuriously. Updated to use a more precise alternation with
non-capturing groups and `\R` for line breaks.

---

## Refactored: `<array>` Tag Dispatch Table

The `finalize()` method in `TagX::TAG::NoBody::Array` has been
refactored from a chain of `if/elsif` blocks to an ordered dispatch
table using `List::Util::pairs`. Constructor options (`--handle`,
`--file`, `--bedrock-xml`, `--json`, `--expand`) are now entries in
an `@rules` array that preserves priority order, with a `default`
sentinel at the end.

---

## Dead Code Removed

### `If.pm` `xfile_test()`

The `xfile_test()` subroutine in
`TagX::TAG::WithBody::If` has been removed. This function performed
file-test operations via `eval` of a stringified test expression but
was no longer called from anywhere in the codebase.

---

## Documentation Updates

- **`Bedrock::Hash`**: POD updates including new `devolve()`
  documentation
- **`Bedrock::Array`**: POD updates for `devolve()`, `sort()`,
  `smart_sort()`, `smart_sort_desc()`, and `recordset()` methods
- **`docker/README.md`**: clarified Chromebook tunnel instructions,
  removed hardcoded IP addresses, added guidance on DNS resolution
  using Firefox/Chromium inside the Linux container
- **`docker/web-tunnel`**: replaced literal IP with placeholder
  hostname in examples
- **`SessionManager`**: POD updated to reflect `Crypt::URandom`-based
  session identifiers

---

## Build and Packaging

- `Bedrock::Iterator` added to RPM spec, CPAN Makefile, and
  `lib/Makefile.am`
- `Crypt::URandom` added to CPAN requires
- `Digest::MD5` dependency removed from session modules
