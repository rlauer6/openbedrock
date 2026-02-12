# Bedrock 3.8.2 Release Notes

**Release Date:** February 12, 2026

This release focuses on architectural improvements to the MiniServer,
the introduction of the TemplateHelper role for cleaner "algorithmic
gymnastics" in templates, and enhanced path resolution for complex
routing.

---

## Major Features

### Bedrock::Role::TemplateHelper

A new `Role::Tiny` based role that allows any Bedrock Service to
inject utility methods into templates. This replaces the need for full
plugins when simple data transformation is required.

**Features:**

* **Isolation:** Helpers live in a nested `_helper_` namespace under the
caller's class.


* **Persistence Safe:** Closures are re-assigned on every request,
ensuring variables like `$mount` or `$cgi` are always current.


* **Clean Syntax:** Methods can be called directly in templates via
  `<var $util.method_name()>`.

### MiniServer Routing & Path Resolution

The MiniServer received a significant update to improve parity with
`mod_perl` and Apache.

* **Exact Service Matches:** The server now checks for exact mount-point
matches before proceeding to alias or template resolution.


* **PATH_TRANSLATED Support:** A new internal resolver determines the
physical path for captured routes, injecting `PATH_TRANSLATED` into
the environment for CGI/Service compatibility.


* **Directory Handling:** The static server now declines paths that are
directories (`-d`), allowing a `DirectoryIndex` service to handle the
request.


---

## Tag & Module Improvements

### TagX::Scalar `fileparse`

Added a `fileparse` method to `Bedrock::Text::TagX::Scalar` (and by
extension, `TagX::Scalar`).

* Uses `File::Basename` to return a `Bedrock::Hash` containing `name`,
  `path`, and `ext`.


**Example:** `<var $filename.fileparse().name>`.


### Bedrock::Router Greedy Captures

The `_compile_pattern` method now recognizes `*parameter`.

* `:parameter` remains a non-greedy match (up to the next `/`).


* `*parameter` performs a greedy match (`.+`), capturing everything
remaining in the URI.

---

## New Services

### Bedrock::Service::DirectoryIndex

A new core service that automatically generates a file listing for a
given directory.

* Uses the `TemplateHelper` role to transform file names into routes
  (e.g., converting `.md` files to `/markdown` URLs).


* Designed to serve as a default fall-through for directory requests
  in the MiniServer.

---

## Bug Fixes

* **Bedrock::Service:** Fixed `flush_output` to ensure headers are sent
even if the output buffer is empty.


* **Bedrock::LSP:** Removed `sink` from the raw tag list to improve
editor highlighting and parsing.


* **Bedrock::Template:** Corrected internal accessor and dependency
ordering.


* **MiniServer Context:** Added missing proxy methods for `method`,
`path_info`, and `path_translated` to the internal context object.


---

## Build System Changes

* **cpan/bedrock-core:** Replaced `test-tag.pl` with `bedrock-runner.pl`
across all Makefiles and buildspecs.


* **Makefile.am:** Added `Bedrock::Role::TemplateHelper` and
`Bedrock::Service::DirectoryIndex` to the build and install lists.

---

## Backward Compatibility

### Migration Notes

* **Test Runners:** Symlinks pointing to the old `test-tag.pl` should be
updated to `bedrock-runner.pl`.


* **MiniServer Aliases:** If you relied on the MiniServer serving raw
directory listings, you should now mount
`Bedrock::Service::DirectoryIndex` at your desired path.

---

## Testing

* **New Test Orchestration:** The transition to `bedrock-runner.pl` and
`bedrock-test.pl` is complete.


* **MiniServer Verification:** Verified exact route matching and path
translated resolution in standalone environments.
