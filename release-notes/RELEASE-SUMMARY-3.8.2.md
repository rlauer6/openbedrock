# Bedrock 3.8.2 - Quick Summary

**Released:** February 12, 2026

## Highlights

**Template Helper Role**

* New `Bedrock::Role::TemplateHelper` for injecting custom Perl logic
  into templates.
* Prevents namespace collisions by using service-specific isolation.
* Re-binds closures on every request in persistent environments
  (MiniServer) to capture request-specific lexical scope.

**MiniServer Path Sovereignty**

* Enhanced support for `PATH_TRANSLATED` and `SCRIPT_FILENAME`
  environment variables.
* Improved route matching: exact service matches are prioritized
  before falling back to aliases or templates.
* Static file server now declines directory requests, allowing them to
  fall through to the Service Registry.

**Router & Tag Enhancements**

* `Bedrock::Router` now supports greedy captures using the `*path`
pattern.

* New `fileparse` method for `TagX::Scalar` (and standard `<var>`
  tags) to extract name, path, and extension from file strings.

**New Directory Index Service**

* `Bedrock::Service::DirectoryIndex` provides a built-in, customizable
directory listing service.

## Examples

### Using the new Template Helper Role

```
# In your Service class
with 'Bedrock::Role::TemplateHelper';

sub action_index {
    my $self = shift;
    my $util = $self->create_helper(
        to_url => sub { 
            my ($self, $file) = @_;
            return "/myapp/docs/$file"; 
        }
    );
    $self->parse('index.roc', util => $util);
}

```

### Greedy Route Capture

```
# In routes.yml / bedrock-miniserver.yml
routes:
  /docs:
    '*path': 'documentation_template.roc'
# Matches /docs/any/nested/path and captures into $path

```
