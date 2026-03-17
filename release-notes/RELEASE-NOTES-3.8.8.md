# Bedrock Release Notes - Version 3.8.8

**March 16, 2026 · TBC Development Group**

---

## Overview

Bedrock 3.8.8 focuses on three themes: **MiniServer maturation**, **Apache decoupling**, and
**distribution hygiene**. The MiniServer is refactored from a single monolithic script into proper
installable modules, gains zero-config application scaffolding, and now loads the full Bedrock
configuration pipeline at startup - the same pipeline used by `Apache::Bedrock` in production.
Apache-specific dependencies are simultaneously demoted to optional recommendations, making a bare
`cpanm Bedrock` install viable for the first time without an Apache environment.

---

## Highlights at a Glance

| Component | Change |
|---|---|
| `MiniServer` | Refactored into `Bedrock::MiniServer` + `Bedrock::MiniServer::CLI` |
| Zero-config start | `bedrock-miniserver.pl` with no args scaffolds a complete application |
| Config pipeline | Full `tagx.xml` / `config.d` merge loaded at startup (same as Apache) |
| Apache decoupling | Apache deps moved to `recommends`; bare `cpanm Bedrock` now works |
| `Bedrock::FauxHandler` | New production alias for `Bedrock::Test::FauxHandler` |
| `Bedrock::CSRF` | Full POD documentation with AJAX token-refresh pattern |
| Bedrock-Core dist | `Bedrock::Error` and `Bedrock::Exception` moved here from Bedrock |
| Docker image | New `bedrock-lite` Dockerfile installs from DarkPAN via `cpanm` |
| HTTP status logging | Request log now includes HTTP status codes |
| `BLM::Startup::Bedrock` | New `dist_dir()` method exposes distribution directory to templates |

---

## MiniServer Refactored into Proper Modules

Prior to 3.8.8, `bedrock-miniserver.pl` was a self-contained script housing `package
Bedrock::MiniServer` and `package Bedrock::MiniServer::CLI` inline. These packages are now
extracted into their own installable modules:

- `Bedrock::MiniServer` - the `HTTP::Server::Simple::CGI` subclass that handles requests
- `Bedrock::MiniServer::CLI` - the `CLI::Simple` subclass that parses options and orchestrates startup
- `bedrock-miniserver.pl` - now a thin launcher that delegates to `Bedrock::MiniServer::CLI`

This separation means both modules are independently installable,
testable, and importable. Code that previously had to exec the script
can now `use Bedrock::MiniServer` directly.

### bedrock_server_config Now a Setter

The `bedrock_server_config` accessor on `Bedrock::MiniServer` now accepts an argument, making it a
proper setter in addition to a getter. This is needed for test harnesses and programmatic server
construction where the runtime config must be injected after instantiation.

---

## Zero-Config Application Scaffolding

Running `bedrock-miniserver.pl` with no arguments in an empty directory now scaffolds a complete
Bedrock application tree:

```
./bedrock-miniserver.yml    # generated server configuration
./html/                     # document root
./html/index.roc            # default index (redirects to status page)
./config/                   # Bedrock configuration
./config/tagx.xml           # seeded from distribution defaults
./config.d/                 # configuration overlays
./config.d/plugin/          # application plugin configs
./config.d/startup/         # startup module configs
./pebbles/                  # Bedrock pebble templates
./include/                  # include files
./session/                  # session file storage
```

The generated `tagx.xml` is copied from the distribution's reference configuration with paths
adjusted for local development (`PEBBLE_DIR`, `SESSION_DIR`, `INCLUDE_DIR` set to the scaffolded
directories). `REPLACE_CONFIG: yes` is set so the local config stands alone and
`ALLOW_SNIPPET_TAG` is enabled for development convenience.

The generated `bedrock-miniserver.yml` sets `BEDROCK_CONFIG_PATH` in the `env:` block, pointing at
the local `config/` directory. The server listens on port 8080 by default and redirects the root
to the server status page on first visit.

> **Note:** The zero-config scaffolding is designed so the generated layout transfers directly to
> an Apache production deployment. Paths, config structure, and plugin layout are identical to what
> `Apache::Bedrock` expects.

---

## Full Bedrock Configuration Pipeline at Startup

Previous versions of the MiniServer loaded a bare `Bedrock::Config` object on each request.
3.8.8 changes this: `cmd_start_server` now calls `Bedrock::Handler` to load a fully merged
Bedrock configuration at startup using the same pipeline as `Apache::Bedrock`:

- `tagx.xml` is located via `BEDROCK_CONFIG_PATH`
- Multiple `tagx.xml` files along the config path are merged
- Plugin configs in `config.d/plugin/` are discovered and merged into `MODULES`
- Startup module configs in `config.d/startup/` are likewise merged
- Data sources from `data-sources.xml` files are registered

The resulting config object is cached for the life of the server process and reused for every
template request. This eliminates per-request config loading overhead and ensures the MiniServer
environment matches what templates see under Apache.

### Routes Merged from Bedrock Config and Miniserver YAML

Routes defined in the Bedrock configuration (typically `routes.xml`) are now loaded at startup and
merged under the root (`/`) mount point alongside routes defined in the miniserver YAML. Miniserver
YAML routes take precedence on a per-mount-point basis. Captured parameters from `Bedrock::Router`
patterns are available in templates via `$input`.

### overrides: Block Clarified

The `overrides:` block in `bedrock-miniserver.yml` is now clearly documented as values applied on
top of the merged `tagx.xml` config at startup - not a replacement for `BEDROCK_CONFIG_PATH`. The
`BEDROCK_CONFIG_PATH` setting moves to the `env:` block where it belongs, and `overrides:` is
reserved for values like `ALLOW_SNIPPET_TAG` that tune behavior on top of the merged config.

---

## Apache Dependencies Are Now Optional

The four Apache-specific modules have been removed from `requires` and placed in a new `recommends`
file:

```
Apache::ConfigParser
Apache2::Request
Apache2::Upload
mod_perl2
```

A bare `cpanm Bedrock` now installs cleanly in any environment without Apache headers or `apxs`
present. To install with Apache support:

```bash
cpanm --with-recommends Bedrock
```

The Apache handler files (`Bedrock::Apache::*`) are still distributed with Bedrock - they are
simply inert unless `mod_perl2` is loaded at runtime.

A new `cpan/requires-no-apache` file is also provided for build scenarios that explicitly target
Apache-free environments.

---

## New Modules

### Bedrock::FauxHandler

A thin subclass of `Bedrock::Test::FauxHandler` intended for production use outside of test
harnesses. Code that previously had to `use Bedrock::Test::FauxHandler` in non-test contexts can
now `use Bedrock::FauxHandler` for a cleaner namespace signal.

---

## Bedrock::Test::FauxHandler Improvements

Two changes improve usability in non-standard logging configurations:

- **Caller-supplied logger:** `new()` now accepts a pre-built logger object via the `log` option.
  Previously a `Bedrock::Test::FauxLogger` was always instantiated unconditionally, making it
  impossible to inject a custom logger without subclassing. The `log_level` option is now a
  fallback used only when constructing the default FauxLogger.

- **Safe DESTROY:** The `DESTROY` method now calls `close` on the logger only if the logger
  `can('close')`. This prevents exceptions when using loggers that do not implement a `close`
  method (such as `Log::Log4perl` loggers).

---

## Distribution Boundary Changes

### Modules Moved to Bedrock-Core

`Bedrock::Error` and `Bedrock::Exception` are now part of the `Bedrock-Core` distribution. These
modules are used throughout the core template engine and have no business being in the `Bedrock`
distribution. Applications that `use Bedrock::Error` or `use Bedrock::Exception` will continue to
work without any change, since `Bedrock-Core` is always a prerequisite of `Bedrock`.

### Modules Removed from Bedrock Distribution Provides

The following modules were listed in the `Bedrock` distribution's `provides` but actually live in
`Bedrock-Core`. They are removed from the `Bedrock` buildspec to avoid confusing the CPAN indexer
(Orepan2) and prevent `cpanm` from incorrectly short-circuiting the `Bedrock` install:

- `BLM::Startup::Bedrock`
- `BLM::Startup::Config`
- `BLM::Startup::Env`
- `BLM::Startup::Header`
- `BLM::Startup::Input`
- `Bedrock::Pager`

These modules remain installable and usable - they are simply no longer redundantly claimed by two
distributions.

---

## Bedrock::CSRF - Full Documentation

`Bedrock::CSRF` receives comprehensive POD in this release, including:

- Standard form protection pattern (hidden field + server-side check)
- AJAX token-refresh pattern - every AJAX response returns the new token after rotation, with a
  client-side interceptor updating all form fields
- Login/logout token rotation to prevent session fixation attacks
- Security notes covering token entropy, storage model, timing attack considerations, and
  single-use semantics

Tokens are 64 hex characters (256 bits) generated via `Crypt::URandom`. The token is automatically
rotated after every `check_csrf_token` call - whether validation succeeded or failed - making each
token single-use.

---

## BLM::Startup::Bedrock - New dist_dir() Method

A new `dist_dir()` method is added to `BLM::Startup::Bedrock`, exposing
`$Bedrock::BEDROCK_DIST_DIR` to templates via the `$bedrock` object:

```
<var $bedrock.dist_dir()>  <!-- prints the distribution share directory path -->
```

Useful for bootstrapping templates that need to locate distribution assets (images, CSS, default
configuration files) without hardcoding paths.

---

## HTTP Status Code Logging

The `_log_complete` method in `Bedrock::MiniServer` now accepts and logs an HTTP status code
alongside the request method, path, and timing. All request dispatch paths - exact service match,
directory index, alias resolution, template route, and service prefix match - now capture and
report the response status. Previously the log showed only that a request completed, with no
indication of whether it returned 200, 404, or 500.

---

## New bedrock-lite Docker Image

A new `docker/Dockerfile.bedrock-lite` is introduced for building a minimal Bedrock deployment
image:

- **Base image:** `debian:trixie-slim`
- **Install source:** `cpan.openbedrock.net` DarkPAN mirror, with CPAN as fallback
- **Build toolchain purge:** `gcc`, `make`, and header packages removed in the same `RUN` layer as
  the install to keep the final image layer small
- **`cpanm` itself removed:** not needed at runtime; purged after install

The Bedrock CPAN mirror is set via `PERL_CPANM_OPT` with `--mirror-only`, ensuring DarkPAN
packages take precedence. The fallback to `metacpan.org` covers all standard CPAN dependencies not
hosted on the DarkPAN.

---

## Upgrade Notes

### No Breaking Changes

All public interfaces are backward-compatible. Existing `bedrock-miniserver.yml` configuration
files, templates, services, and `use` statements work without modification.

### Recommended Configuration Update

If you have `BEDROCK_CONFIG_PATH` set in your `overrides:` block, move it to the `env:` block:

```yaml
# Before (still works, but deprecated usage):
overrides:
  BEDROCK_CONFIG_PATH: ./config

# After (correct placement):
env:
  BEDROCK_CONFIG_PATH: ./config
overrides:
  ALLOW_SNIPPET_TAG: yes
```

### Apache Deployments

No changes required. The Apache handlers are still installed as part of Bedrock. If you are
building Docker images or CI pipelines that install Bedrock in a non-Apache environment, you can
now omit `--with-recommends` and the build will no longer attempt to install `mod_perl2`, which
previously required Apache development headers.

### Bedrock-Core Users

If you install only `Bedrock-Core` (for daemons or scripts), `Bedrock::Error` and
`Bedrock::Exception` are now included in that distribution and no longer require installing the
full `Bedrock` distribution.

---

## Files Changed

**New files:**

- `src/main/perl/lib/Bedrock/MiniServer.pm.in` - extracted HTTP server class
- `src/main/perl/lib/Bedrock/MiniServer/CLI.pm.in` - extracted CLI class
- `src/main/perl/lib/Bedrock/FauxHandler.pm.in` - production alias for FauxHandler
- `cpan/recommends` - new file listing optional Apache dependencies
- `cpan/requires-no-apache` - explicit Apache-free requirements list
- `docker/Dockerfile.bedrock-lite` - minimal DarkPAN-based Docker image

**Modified files:**

- `src/main/perl/bin/bedrock-miniserver.pl.in` - reduced to launcher + POD
- `src/main/perl/lib/Bedrock/CSRF.pm.in` - comprehensive POD added
- `src/main/perl/lib/Bedrock/Test/FauxHandler.pm.in` - optional logger + safe DESTROY
- `src/main/perl/lib/BLM/Startup/Bedrock.pm.in` - new `dist_dir()` method
- `cpan/requires` - Apache deps removed
- `cpan/buildspec.yml` - `recommends` added; distribution boundary cleanup
- `cpan/bedrock-core/buildspec.yml` - `Bedrock::Error` and `::Exception` added

---

*Bedrock 3.8.8 · TBC Development Group · http://github.com/rlauer6/openbedrock*
