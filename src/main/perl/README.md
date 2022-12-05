# Quickstart - Running the Tag Unit Tests

## Running the tests

From the project root...

```
$ make
$ cd src/main/perl
$ make test
```

As shown above, tests are run my invoking `make`.  The `Makefile.am`
file controls which tests are run...in other words only the tests
specified in the `Makefile.am` will be run. See [Adding
a New Tests](#adding-a-new-test) for more details.


> Note that in order to run all tests you need to have a MySQL
> database running. See [SQL Tests](#sql-tests) for more details.


# README

This is the README for the Bedrock tag test suite. This __should__
always be a work-in-progress...

Since unit tests were not created when the project began, an attempt
is being made to at least add unit tests whenever a problem is found
or new features are added to Bedrock. There are __still__ many untested features
of Bedrock, so again, new tests __should__ be added whenever code is
refactored or bugs are found.

The intent of these particular tests is to exercise tag features and
behavior. _A successful run of these tests does not necessarily mean
Bedrock is working in as a web framework. More tests that exercise
Bedrock in that context are required._

Additional tests of specific Bedrock Perl modules can be found in the
`src/main/perl/lib` directory.

# Where are the Tests?

## Test Ordering

The tests are located in the `src/main/perl/t` directory. Tests are
sequentially named with a number to insure they are run in a specific
order. Test names follow the convention:

`{nn}-{test-name}.yml`

Where `{nn}` is a 0 padded integer and `{test-name}` is the name of
the test. Test names should generally be indicative of the tag being
tested. For example `12-sqlconnect.yml`.

The integer prefix is used to order the tests. The order of tests
should place tags that exercise the core features of
Bedrock first and other tags that are possibly dependent on those
features later.

## Test File Format

Tests files are YAML files with an extension of `.yml`, not the
traditional `.t`. Test files are essentially a description of a test
instead of actual _code_ that executes a traditional unit test.

The test descriptions are interpretted by a test harness
`test-tag.pl`. In effect the unit test code is `test-tag.pl` with a
parameter indicating the `.yml` file to use as input to the test harness.

`Makefile.am` creates a symbolic link for each test description with an
extension of `.t` so that the `prove` program will execute these as
tests.  The symbolic link actually points to the `test-tag.pl` test harness and
through a little bit of magic executes the right test file.

See `Bedrock::Test` and `test-tag.pl` to understand more about how the
tests are actually executed.

For more information regarding how to construct test descriptions, see
`perldoc test-tag.pl`.

## Running One or More Tests

You can run a single test by setting the environment variable `TESTS`
to the test name (if it is unique) or the test file name.

```
make test TESTS=sqlconnect
make test TESTS=12-sqlconnect.yml
```

Similarly, you can a set of specific tests by setting `TESTS` to one
or more test names.

make test TESTS="sqlconnect sql sqlselect"

## Running Just the SQL Tests

```
make test TESTS=sql
```
# Where are the Test Logs?

When you run the unit tests, Bedrock will create logs with that aid in
debugging.  Bedrock is capable of both internal logging designed to
debug Bedrock itself, adds messages to the logs for Bedrock
applications when one or more `--verbose` options are included in a
tag. Log file configuration for testa and application usages is
controlled by a `log4perl.conf` file located in `src/main/perl/t`. You
can further tune Bedrock log verbosity by modifying this file. In
general each Bedrock Perl module uses `Log::Log4perl` meaning you can
control logging at a Perl module level by adding categories. For
example, to log at the TRACE level within `BLM::Startup::UserSession`
add a category like this:

```
log4perl.category.BLM.Startup.UserSession=TRACE, Bedrock
log4perl.additivity.BLM.Startup.UserSession=0
```

The `log4perl.conf` configuration for testing tags defines two
appenders.

```
 ### Bedrock
 log4perl.appender.BedrockTest=Log::Log4perl::Appender::File
 log4perl.appender.BedrockTest.filename=bedrock-test.log
 log4perl.appender.BedrockTest.mode=append
 log4perl.appender.BedrockTest.autoflush=1
 log4perl.appender.BedrockTest.layout=PatternLayout
 log4perl.appender.BedrockTest.layout.ConversionPattern=%d (%r) (%p) [%P] [%l] %c - %m%n
 
 ### TagX
 log4perl.appender.TagX=Log::Log4perl::Appender::File
 log4perl.appender.TagX.filename=bedrock-page.log
 log4perl.appender.TagX.mode=append
 log4perl.appender.TagX.autoflush=1
 log4perl.appender.TagX.layout=PatternLayout
 log4perl.appender.TagX.layout.ConversionPattern=%d (%r) (%p) [%P] [%l] %c - %n%m%n
```

...hence, tests will produce two log files (`bedrock-test.log`,
`bedrock-page.log`).

Three categories are defined that control where log information is
written.

```
 ### Bedrock::Apache::Bedrock
 log4perl.category.Bedrock.Apache.Bedrock=DEBUG, BedrockTest
 
 ### Bedrock::
 log4perl.category.Test.Bedrock=DEBUG, BedrockTest
 
 ### TagX::
 log4perl.category.TagX=INFO, TagX
```

The way the categories are defined causes most of Bedrock's internal
processing other than actual tag processing to log to the
`bedrock-test.log` file. Tag processing is logged to
`bedrock-page.log` at the `INFO` level to avoid a noisy
`bedrock-page.log` which is used to log user level messages when the
`<trace>` tag is used.

In short when you run `make test`, your logfile will be found in the
`src/main/perl` directory as `bedrock-test.log`.

The `<trace>` tag can take arguments (Bedrock object) or
stand-alone it will indicate the point (line number) in the snippet at
which it was encountered.

```
test: |
  <trace $foo> 
  ...
```

---

# Test File Format

For more information regarding how to construct test descriptions, see
`perldoc test-tag.pl`.

# Adding a New Test

As noted above, tests are specified in the `Makefile.am` file, s don't
expect that if you place more _test_ files in the project they will be
automatically executed when you invoke `make test`! Follow the recipe
below to add a new test to the project.

1. Create a new `.yml` file in the `src/main/perl/t` directory.

   ```
   $ cat > t/15-include.yml
   name: <include>
   test: <open:foo --mode="w" "/tmp/foo.inc"><sink $foo>bar</sink><null $foo.close><include --file="/tmp/foo.inc">
   result: bar
   ^D
   ```
1. Edit the `Makefile.am` file in the `src/main/perl` directory and
   add the test to the TESTS collection.

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
1. Run the test
   ```
   make test TESTS=include
   ```
1. Add the test to the git repository
   ```
   git add t/15-include.yml
   ```
   
# Overriding Environment and Configuration Variables

Bedrock provides objects (`$env`, `$config`) that provide access to
environment variables and Bedrock's configuration.  While your test
snippet is running you also have access to the `$env` and `$config`
objects.  These are simply hashes that provide access to that
information.

Using environment variables allows you to alter the way your snippet
behaves.

```
 test: |-
   <if $env.FOO --eq 'bar'>
     ...do the 'bar' stuff
   <else>
     ...don't do the 'bar' stuff
   </if>
```

...then...

```
$ make test FOO=bar
```
You can do the same thing by setting values in your configuration file
`<tagx.xml>`.

You can point the tests to your custom Bedrock configuration file by
settting the `BEDROCK_CONFIG_PATH` environment variable.

    $ BEDROCK_CONFIG_PATH=/tmp make test

The test script will look for a `tagx.xml` file in that directory,
otherwise it will look in the source tree (`src/main/bedrock/config`)
for this project.

## Specifying Environment and Configuration Values in Test Descriptions

You can also override the environment and configuration values in
`tagx.xml` temporarily for one test by setting the values in the test
description.

```
 name: <sqlconnect> dsn, but no user
 env:
   DBI_USER:
   DBI_PASS:
 config:
   DBI_USER:
   DBI_PASS:
   DBI_DSN:
   DBI_HOST:
 test: |
   <try>
     <sqlconnect:dbi --verbose dbi:mysql:bedrock:localhost mysql_socket $env.DBI_SOCKET>
     <iif $dbi success 'no dbi'>
   <catch>
     <var $@>
   </try>
 result: '/no user found/'
 op: like
```

---

# SQL Tests

Testing the SQL tags `<sql>`, `<sqlconnect>` and `<sqlselect>` require a
running MySQL server with a `bedrock` database. You should also have a
`session` table defined. The recipe below _should_ work to create the
necessary environment for testing.

1. Create the database and session table
   ```
   mysqladmin -u root create bedrock
   cat ../bedrock/config/mysql-session.sql | mysql -u root bedrock
   ```
1. Grant user `fred` privileges. Test will be run with user=`fred`,
password=`flintstone`.
   ```
   grant all on *.* to 'fred'@'%' identified by 'flintstone'
   ```
1. Run the tests. If your MySQL server is accessible as `localhost` you can simply run
the tests thusly:
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
this project, it would have also launched a MySQL server with a root
password of `bedrock`. To access this server you can use a host
parameter of `127.0.0.1` or pass the socket which was shared locally.

```
mysql -u root --p -h 127.0.0.1
```

or

```
mysql -u root -p -h localhost --socket=/tmp/mysqld/mysqld.sock
```

To run tests using this MySQL host:

```
TESTS=all make test
```
