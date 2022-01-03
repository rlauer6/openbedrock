# README

This is the README for the Bedrock tag test suite.  This is currently
a work-in-progress and we are actively adding tag tests all the time.
The intent of these particular tests is to test tag behavior, not to
test the entire Bedrock framework as it executes in a web server
environment.

# Running the tag tests

    $ cd src/main/perl
    $ make test

# Where are the tests?

The tests are located in the `src/main/perl/t` directory and stored
with an extension of `.yml`, not the traditional `.t`.  A test harness
will create symbolic links with an extension of `.t` so that the
`prove` program will execute these as tests.  The symbolic link points
to the `test-tag.pl` test harness and through a little bit of magic
executes the right test file.

See `Test::Bedrock` and `test-tag.pl` to understand more about how the
tests are actually executed.

# Where are the test logs?

Bedrock normally creates a page log of each page it parses.  Likewise
the tests will produce a log for each test file it
encounters. Depending on the tag and whether you've included the
`--verbose` option you will find varying degrees of information in a file
named `/tmp/test-tag_{filename}.txt`.  Where `{filename}` is the name
of the test file.  For example for the test file `null.txt`, there
will be a `/tmp/test-tag_null.log` file created.

All of the tests in that file will share the same log file.  The
`<trace>` tag can be used to potentially log useful information for
your test.  The `<trace>` tag can take arguments (Bedrock object) or
stand-alone it will indicate the point (line number) in the snippet at
which it was encountered.

    test: |
      <trace $foo> 
      ...

# Test file format

Each of test files is a YAML formatted file that defines several keys
for each test.

    ---
    name: <sink:foo>
    comment: test the <sink> object creation
    test: <sink:foo>foo</sink>
    result: foo

* `name` - the name of the test
* `comment` - arbirtray comment
* `test` - the Bedrock snippet that defines the test
* `result` - the expected result

By default the `result` value is compared with the output produced by
the test snippet.  If the result is exactly equal to the output, then
the test is successful.  You can use the key `op` to use comparisons
other than "equals".

* `is`
* `isnt`
* `like`
* `unlike`
* `cmp_ok`

## Testing Tips

To test the value of an exception thrown by Bedrock, set the key
`error` instead of `result`.  Use regular expression (enclosed in //)
for the `like` operator.

    ---
    name: invalid type
    test: <null:hashref:foo foo>
    error: /invalid type/
    op: like

To test longer Bedrock snippets use the literal form of YAML and the
chomp (-) indicator to remove final new lines.

    ---
    name: <try/catch>
    test: |-
      <try>
        <null:hashref:foo foo>
      <catch 'invalid type'>
        <flush>1</catch>
    result: 1

Of course, feel free to flex your regexp prowess!!

    ---
    name: <try/catch>
    test: |
      <try>
        <null:hashref:foo foo>
      <catch 'invalid type'>
        1
      </try>
    result: /^\s*1\s*$/s
    op: like

# Adding a new test

Add a new `.txt` file to the `src/main/perl/t` directory.

    $ cat > t/include.txt
    ---
    name: <include>
    test: <open:foo --mode="w" "/tmp/foo.inc"><sink $foo>bar</sink><null $foo.close><include --file="/tmp/foo.inc">
    result: bar
    ^D
    
    $ perl -i.bak -np -e 's/^TESTS = \\$/TESTS = \\\n    t\/foo.txt \\/;' Makefile.am

...or just edit the `Makefile.am` file and add the test to the TESTS collection.

    TESTS = \
        t/flush.txt   \
        t/foo.txt     \
        t/if.txt      \
        t/include.txt \
        t/null.txt    \
        t/open.txt    \
        t/plugin.txt  \
        t/sink.txt    \
        t/try.txt     \
        t/var.txt
    
Don't forget to add the test to the repo.

    $ git add t/foo.txt

# `$env`, `$config`

Normally, Bedrock provides objects for you that provide access to
environment variables and Bedrock's configuration.  While your test
snippet is running you have access to the `$env` and `$config`
objects.  These are simply hashes that provide access to that
information.

You can also point the tests to your Bedrock configuration file by
settting the `BEDROCK_CONFIG_PATH` environment variable.

    $ BEDROCK_CONFIG_PATH=/tmp make test

The test script will look for a `tagx.xml` file in that directory,
otherwise it will look in the source tree for this project.

You can alter the way your snippet behaves by setting values in your
configuration file F(<tagx.xml>) or the environment. Suppose I have
snippet show below:

    test: |-
      <if $env.FOO --eq 'bar'>
        ...do the 'bar' stuff
      <else>
        ...don't do the 'bar' stuff
      </if>

...then...

    $ FOO=bar make test
