# Bedrock 3.8.3 Release Notes

**Release Date:** February 13, 2026

---

## New Features

### `pairs()` method for Bedrock Arrays

A new `pairs()` method has been added to `Bedrock::Array`, inspired by
`List::Util::pairs`. It consumes consecutive elements as key/value
pairs and returns an array of hashes with `key` and `value` properties
— a natural fit for Bedrock templates.

```html
<null --define-array="arr" name "Rob" language "Perl">
<foreach $arr.pairs()>
  <var $_.key> = <var $_.value>
</foreach>
```

Dies with a diagnostic message if the array has an odd number of elements.

### Tag Group Browsing in Bedrock Docs

Tags in the built-in documentation system are now organized by
functional group. Each tag module now implements a `group()` method
that categorizes it into one of the following groups:

- **Conditional & Logic Control**
- **Core Data & Variable Management**
- **Database & Transaction Management**
- **Debugging**
- **Extensions**
- **Exception Handling**
- **File & System Integration**
- **Iteration & Loops**
- **Output Control**
- **Template Composition**

The new `/tag` docs endpoint renders tags grouped by category rather
than as a flat alphabetical list, making it much easier to discover
related tags. A new template (`bedrock-docs-tag-groups.inc`) drives
the grouped display, and `pairs()` is used to iterate over the group
data — its first real consumer.

New supporting code in `Bedrock::Service::Docs`:

- `get_tag_groups()` - returns a hash of group name → tag list
- `get_tag_list()` - now populates `%TAG_META` with metadata
  (block/loop flags, options, group) for each tag
- `action_tag()` - updated to render the grouped tag listing; the API
  endpoint now also returns group data

---

## Bug Fixes

### Crash in hash dump when ref is not an array or hash

`bedrock-docs-hash-dump.inc` could crash when encountering a reference
that was neither an array nor a hash (e.g., a code ref or blessed
object). The template now explicitly checks for `--array` or `--hash`
before calling `compact()`, and falls through to `--scalar` for
everything else.

### Miniserver `chdir` for includes

`bedrock-miniserver.pl.in` now changes the working directory to the
served file's directory before parsing, so that `<include>` tags with
relative paths resolve correctly. The original working directory is
restored after parsing (even on error) to avoid side effects.

---

## Documentation & Styling

### Mustard theme for pod.css

The documentation stylesheet has been refreshed:

- `h2` headings now use a mustard-yellow (`#f1c40f`) background with
  dark text, rounded corners, and modern system fonts
- `h3` headings softened to `#555555`
- Improved link styling for `<a><code>` elements (proper color and hover states)
- Cleaned up table border rules for the `.bedrock-docs` container

### Log4perl configuration hidden by default

The Bedrock docs index page now hides the log4perl configuration
section by default to reduce visual clutter, with the section
reordered to appear last.

---

## Code Cleanup

- **`SQLCommit.pm.in`** modernized: replaced `BEGIN`/`Exporter`/`@ISA`
  boilerplate with `use parent`, added `use warnings`, added section
  separators, moved `group()` and `1;` above `__END__`
