# PUBLIC

Bedrock - Used to add Bedrock, Bedrock/Text to @INC and/or import utility functions

# SYNOPSIS

    use Bedrock qw{:all};

    my $text = slurp_file 'foo.txt';

# DESCRIPTION

This module is used to add the `Bedrock` and `Bedrock/Text`
sub-directories of the path to Bedrock's Perl modules to
`@INC`. Because the module hierarchy is so deep it became easier to
and clearer in modules to use:

    use TagX::TAG;

rather than...

    use Bedrock::Text::TagX::TAG;

...or even more deeply into the hierarchy...

    use TagX::TAG::WithBody::If;

rather than...

    use Bedrock::Text::TagX::TAG::WithBody::If;

The module also provides a set of utilities that can be imported by Bedrock modules.

# EXPORT TAGS

## :all

`:booleans`, `:file`, `compile_regexp`, `force_array`

## :booleans

    is_array
    is_bedrock_array
    is_bedrock_hash
    is_blessed
    is_hash
    is_regexp
    is_scalar

## :file

    create_temp_file
    slurp_file
    find_in_path

# METHODS AND SUBROUTINES

## OBJECT METHODS

### is\_array

Equivalent to:

    ref $x && reftype($x) eq 'ARRAY'

### is\_bedrock\_array

Equivalent to:

    ref $x && ref($x) eq 'Bedrock::Array'

### is\_bedrock\_hash

Equivalent to:

    ref $x && ref($x) eq 'Bedrock::Hash'

### is\_blessed

Equivalent to:

    ref $x && blessed($x)

### is\_hash

Equivalent to:

    ref $x && reftype($x) eq 'HASH'

### is\_regexp

Equivalent to:

    ref $x && ref($x) eq 'Regexp'

### is\_scalar

Equivalent to:

    ref $x

## FILE UTILITIES

### find\_in\_path

    find_in_path(options)

In list context, returns a list of files found in a list of path based
on a filter pattern or a file name. In scalar context, returns the
number of files found.

Either `file` or `pattern` is required. Options are described below:

- max\_items

    Maximum number of items to return.

- path\_list

    An array reference to a list of paths to search. If no `path_list` is
    passed or the list is empty, the current working directory (and it's
    sub-directories) will be traversed.

- file

    The name of the file to search for.

- pattern

    A regular expression that will be used as a filter.

Examples:

Find the first occurrence of file `foo` in current working directory ( and sub-directories
).

    my ($file) = find_in_path(file => 'foo', max_items => 1);

More less equivalent to:

    $ find . -name foo

Find all files named `foo` in a list of directories.

    my @files = find_in_path( file => 'foo', path_list => [ $ENV{PATH} ] );

Find all `.xml` files in list of directories.

    my @xml_files = find_in_path(pattern => qr/[.]xml$/, path_list => [$ENV{CONFIG_PATH}]);

### slurp\_file

Returns entire contents of a file. Throws an exception if the file
cannot be opened.

### create\_temp\_dir

Creates a temporary directory (or sub-directories) and optionally
populates those directories copies with files from a manifest. Returns
the name of the temporary directory created.

    create_temp_dir(options)

- cleanup

    Boolean that indicates that the directory and all files beneath it
    should be removed when the program terminates.

- manifest

    Reference to a hash where each element of the hash represent a set of
    files to be copied from a soruce to a sub-directory of the temporary
    directory.

    - source

        Source of the files to copy.

    - dest\_dir

        Destination directory.  If omitted, files are copied to the root of
        the temporary directory.

    - files

        List of file names to copy.

- dir

## MISCELLANEOUS

### force\_array

Returns a reference to an array that contains the passed
parameter(s). If the passed value is already an array reference it is
simply returned. This method is useful for ensuring a value is a
reference or creating a new array reference from a list.

    my $array = force_array(@_);

# AUTHOR

Rob Lauer - <rlauer6@comcast.net>
