# README

This is the README for the Bedrock tag test suite. This is currently
a work-in-progress since unit tests were not created when the project
began. There are many untested features of Bedrock so new tests __should__
be added whenever code is refactored or bugs are found.

The intent of these particular tests is to test tag behavior. The
tests do not necessarily test Bedrock in a web framework role.

Additional tests of specific Bedrock Perl modules can be found in the
`src/main/perl/lib` directory.

# Running the Tag Unit Tests

## Tag Coverage

    $ cd src/main/perl
    $ make test

# Where are the Tests?

The tests are located in the `src/main/perl/t` directory. Test are
sequentially named with a number to insure an order that places core
tags first and other possibly dependent tags later. Tests have an
extension of `.yml`, not the traditional `.t`, since they are test
descriptions, not the code that executes a traditional unit test.

The test descriptions are interpretted by a test harness
`test-tag.pl`, so in effect the unit test being executed is
`test-tag.pl` with a parameter indicating the `.yml` file to use as
input to the test harness.

The Makefile creates a symbolic link for each test description with an
extension of `.t` so that the `prove` program will execute these as
tests.  The symbolic link points to the `test-tag.pl` test harness and
through a little bit of magic executes the right test file.

See `Test::Bedrock` and `test-tag.pl` to understand more about how the
tests are actually executed.

For more information regarding how to construct test descriptions, see
`perldoc test-tag.pl`.

# Where are the Test Logs?

Bedrock is capable of logging information as it parses tags and when tags
include on or more `--verbose` options. Log file configuration is
controlled by a `log4perl.conf` file located in `src/main/perl`. You
can further tune Bedrock log verbosity by modifying this file. In
general each Bedrock Perl module uses `Log::Log4perl` meaning you can
control logging at a Perl module level by adding categories.  For
example, to log at the TRACE level within `BLM::Startup::UserSession`
add a category like this:

```
log4perl.category.BLM.Startup.UserSession=TRACE, Bedrock
log4perl.additivity.BLM.Startup.UserSession=0
```

Note that the appender for `Log::Log4perl` is configured to output
logs to STDERR, however the constructor in `Test::Bedrock` will make a
call to `TagX::Log::start_logger` which redirects STDERR to the
logfile passed as option to `test-tag.pl`.  That is is currently set
as `bedrock-test.log`.

In short when you run `make test`, your logfile will be found in the
`src/main/perl` directory as `bedrock-test.log`.

The `<trace>` tag can take arguments (Bedrock object) or
stand-alone it will indicate the point (line number) in the snippet at
which it was encountered.

    test: |
      <trace $foo> 
      ...

# Test File Format

For more information regarding how to construct test descriptions, see
`perldoc test-tag.pl`.

# Adding a New Test

Add a new `.yml` file to the `src/main/perl/t` directory.

    $ cat > t/14-include.yml
    ---
    name: <include>
    test: <open:foo --mode="w" "/tmp/foo.inc"><sink $foo>bar</sink><null $foo.close><include --file="/tmp/foo.inc">
    result: bar
    ^D
    
Edit the `Makefile.am` file and add the test to the TESTS collection.

```
BEDROCK_TESTS = \
    t/00-var.yml \
    t/01-multi-line.yml \
    t/02-null.yml \
    t/03-if.yml \
    t/04-foreach.yml \
    t/05-iif.yml \
    t/06-open.yml \
    t/07-plugin.yml \
    t/08-reftype.yml \
    t/09-sink.yml \
    t/10-try.yml \
    t/11-snippet.yml \
    t/12-sqlconnect.yml \
    t/13-sql.yml \
    t/14-flush.yml \
    t/15-include.yml
```

Don't forget to add the test to the repo.

    $ git add t/14-include.yml

# `$env`, `$config`

Normally, Bedrock provides objects for you that provide access to
environment variables and Bedrock's configuration.  While your test
snippet is running you have access to the `$env` and `$config`
objects.  These are simply hashes that provide access to that
information.

Using environment variables allows you to alter the way your snippet
behaves.

    test: |-
      <if $env.FOO --eq 'bar'>
        ...do the 'bar' stuff
      <else>
        ...don't do the 'bar' stuff
      </if>

...then...

    $ FOO=bar make test

You can do the same thing by setting values in your configuration file
`<tagx.xml>`.

You can point the tests to your custom Bedrock configuration file by
settting the `BEDROCK_CONFIG_PATH` environment variable.

    $ BEDROCK_CONFIG_PATH=/tmp make test

The test script will look for a `tagx.xml` file in that directory,
otherwise it will look in the source tree for this project.

# Running a One or More Tests

`make test` will run all tests in the `t/` directory. To run a single
test:

```
TESTS=t/14-include.yml make test
```

To run a subset of tests:

```
TESTS='t/14-include.yml t/04-flush.yml' make test
```

# SQL Tests

The SQL tags `<sql>`, `<sqlconnect>` and `<sqlselect>` require a
running MySQL server with a `bedrock` database. You should also have a
`session` table defined. The recipe below _should_ work to create the
necessary environment for testing.

```
mysqladmin -u root create bedrock
cat ../bedrock/config/mysql-session.sql | mysql -u root bedrock
```

Grant user `fred` privileges. Test will be run with user=`fred`,
password=`flintstone`.

```
grant all on *.* to 'fred'@'%' identified by 'flintstone'
```

If your MySQL server is accessible as `localhost` you can simply run
th tests thusly:

```
TESTS=all make test
```

To run *only* the SQL tests:

```
TESTS=sql make test
```

## Docker Environment

If you have launched a local Apache server running Bedrock using the
Docker image created by the `Dockerfile` in the `docker` directory of
the project, it would have also launched a MySQL server with a root
password of `bedrock`. To access this server you can use a host
parameter of 127.0.0.1 or pass the socket which was shared locally.

```
mysql -u root --p -h 127.0.0.1
```

or

```
mysql -u root -p -h localhost --socket=/tmp/mysqld/mysqld.sock
```

To run tests using this MySQL host:

```
TESTS=all DBI_SOCKET=/tmp/mysqd/mysqld.sock make test
```


