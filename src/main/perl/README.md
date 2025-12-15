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
Bedrock is working as web framework. More tests that exercise
Bedrock in that context are required._

Additional tests of specific Bedrock Perl modules can be found in the
`src/main/perl/lib` directory.

# Quickstart - Running the Tag Unit Tests

## Running the tests

From the project root...

```
$ make
$ cd src/main/perl
$ make test
```

This will invoke a test harness that exercises a subset of the Bedrock
tags. There are some additional tests that can be run if you have a
MySQL database available.

As shown above, tests are run my invoking `make`.  The `Makefile.am`
file controls which tests are run...in other words only the tests
specified in the `Makefile.am` will be run - regardless of whether you
have added new tests to the `t/` subdirectory!

See [Adding New Tests](#adding-a-new-test) for more details.

> Note that in order to run ALL tests you need to have a MySQL
> database running. See [SQL Tests](#sql-tests) for more details.

# Bedrock's Docker Container

Fromt the `docker` directory in this project you can build a Bedrock
image that can be used for exploring Bedrock documentation, developing
applications using Bedrock or testing Bedrock.

A `docker-compose` file (`docker-compose-local.yml`) is located in the
project's `docker` directory. It can launch a stack composed of:

* ...a Redis server
* ...a MySQL server (8.4)
* ...an Apache server running Bedrock
* ...LocalStack

## Bringing Up the LAMB Stack

To bring up the Bedrock stack use the command below.

```
BEDROCK=~/git/openbedrock docker-compose up
```
or `bedrock-up`

By default this will bring up just the Apache server and MySQL. To add
Redis or LocalStack:

```
bedrock-up redis localstack
```

In order to use this container for testing, set the environment
variables shown below.

```
export DBI_HOST=127.0.0.1
export DBI_DSN=dbi:mysql:bedrock
export DBI_USER=root
export DBI_PASS=bedrock
```

Create a data source file (`t/data-sources.xml`)
```
<object>
  <object name="bedrock">
   <scalar name="DBI_DSN">dbi:mysql:bedrock:127.0.0.1</scalar>
   <scalar name="DBI_USER">fred</scalar>
   <scalar name="DBI_PASS">flintstone</scalar>
   <scalar name="DBI_SOCKET">/tmp/mysqld/mysqld.sock</scalar>
  </object>
</object>
```

...then to run the tests

```
cd src/main/perl
DBI_SOCKET=/tmp/mysqld/mysqld.sock TEST=all make test
```

# MySQL Container

You can launch MySQL using just the Docker image. Use the
`start-mysql.sh` script in this directory to launch a MySQL 8 server
environment suitable for testing.

The `setup-mysql.sql` script in this directory will be executed when
you start the container. It will:

* set the root user's password to `flintstone`
* create a user name `fred` with a password of `flintstone`
* grant `fred` all privileges on all databases from anywhere
* create a database named `bedrock`
* create a session table named `session`

Then to run tests using this container...

```
DBI_USER=fred \
DBI_PASS=flintstone \
DBI_HOST='127.0.0.1;mysql_ssl=1' \
DBI_SOCKET=$(pwd)/mysqld/mysqld.sock CONFIG_PATH=config make test TEST=sql
```

# Where are the Tests?

The tag tests are located in the `src/main/perl/t` directory. Tests are
sequentially named with a number to insure they are run in a __specific
order__. Test names follow the convention:

`{nn}-{test-name}.yml`

Where `{nn}` is a 0 padded integer and `{test-name}` is the name of
the test. Test names should generally be indicative of the tag being
tested. For example `12-sqlconnect.yml` will test the `<sqlconnect>` tag.

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

You can run a single test by setting the environment variable `TEST`
to the test name (if it is unique) or the test file name. Note as
indicated earlier, tests are designed to run in specific sequence so
you may not be able to run some tests indepdently.

```
make test TEST=sqlconnect
make test TEST=12-sqlconnect.yml
```

Similarly, you can a test a set of tests by setting `TESTS` to one
or more test names.

make test TEST="12-sqlconnect 13-sql 21-sqlselect"

## Running Just the SQL Tests

```
make test TEST=sql
```

# Test Logs

When you run the unit tests, Bedrock will create logs to aid in
debugging.  Bedrock is capable of both internal logging designed to
debug Bedrock itself and creating log messages for Bedrock
applications when one or more `--verbose` options are included in a
tag.

Log file configuration for tests and application usage is
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

The `log4perl.conf` configuration for testing tags defines several
appenders.

```
## Bedrock
log4perl.appender.Bedrock=Log::Log4perl::Appender::File
log4perl.appender.Bedrock.filename=bedrock.log
log4perl.appender.Bedrock.mode=append
log4perl.appender.Bedrock.autoflush=1
log4perl.appender.Bedrock.layout=PatternLayout
log4perl.appender.Bedrock.layout.ConversionPattern=%d (%r) (%p) [%P] [%l] %c - %m%n

## Test
log4perl.appender.Test=Log::Log4perl::Appender::File
log4perl.appender.Test.filename=bedrock-test.log
log4perl.appender.Test.mode=append
log4perl.appender.Test.autoflush=1
log4perl.appender.Test.layout=PatternLayout
log4perl.appender.Test.layout.ConversionPattern=%d (%r) (%p) [%P] [%l] %c - %m%n

 ### TagX
 log4perl.appender.TagX=Log::Log4perl::Appender::File
 log4perl.appender.TagX.filename=bedrock-page.log
 log4perl.appender.TagX.mode=append
 log4perl.appender.TagX.autoflush=1
 log4perl.appender.TagX.layout=PatternLayout
 log4perl.appender.TagX.layout.ConversionPattern=%d (%r) (%p) [%P] [%l] %c - %n%m%n
```

Tests will produce several files

* `bedrock-test.log` - messages generated by the test harness
* `bedrock-page.log` - messages generated while processing tags
* `bedrock.log`- messages generated by other Bedrock modules
* `bedrock-{pid}.log` - messages generated by the request handler

Three categories are defined that control where log information is
written.

```
### Bedrock::*
log4perl.category.Bedrock=DEBUG, Bedrock
log4perl.additivity.Bedrock=0

log4perl.category.Bedrock.Test=DEBUG, Test
log4perl.additivity.Bedrock.Test=0

### TagX::
log4perl.category.TagX.TAG=INFO, Trace
```

The way the categories are defined causes most of Bedrock's internal
processing other than actual tag processing to log to the
`bedrock.log` file. Tag processing is logged to
`bedrock-page.log` at the `INFO` level to avoid a noisy
`bedrock-page.log` which is used to log user level messages when the
`<trace>` tag is used. For more detailed messages at the trace level,
most tags support adding one or more `--verbose` options.

In short when you run `make test`, your logs will be found in the
`src/main/perl` directory.

## PID Log

Note that the fourth log file (`bedrock-{pid}.log`) contains the log
messages generated by the request handler. When running under Apache,
these logs would generally be found where your Apache configuration
indicates they should be written. When running tests, a __faux__
handler is used that captures these log messages to a log file where
the suffix is the pid of the test run. By default messages are logged at
the `debug` level for the handler. You can modify this if you want
less noisy logs by adding an environment variable REQUEST_LOG_LEVEL
with a value of `error`, `warn`, `info`, `debug`, or `trace`. During
this phase of Bedrock's startup however, few messages are logged at
anything but the `debug` level. If you are having issues with Bedrock
starting or finding configuration files, consult this pid log.

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

As noted above, tests are specified in the `Makefile.am` file, so don't
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
1. Run the test to ensure it does what you expect
   ```
   make test TEST=include
   ```
1. Add the test to the git repository, update the ChangeLog, etc, etc
   ```
   git add t/15-include.yml
   ```
   
# Overriding Environment and Configuration Variables

Bedrock provides objects (`$env`, `$config`) that give applications
access to environment variables and Bedrock's configuration.  While
your test snippet is running you also have access to the `$env` and
`$config` objects.  These are simply hashes that provide access to
that information.

Using environment variables, you can alter the way your test snippet
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

You can also set value in your configuration file
(`<tagx.xml>`) that allow you to access values or alter the behavior
of tags that expect values in the configuration file.

You can point the tests to your custom Bedrock configuration file by
settting the `BEDROCK_CONFIG_PATH` environment variable.

    $ BEDROCK_CONFIG_PATH=/tmp make test

By default The test script will look for a `tagx.xml` file in the
`src/main/perl/t/config`.

## Using  Environment and Configuration Values in Test Descriptions

You can also override the environment and configuration values in
`tagx.xml` __temporarily__ for one test by setting the environment and
configuration values in the test description.

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

Before you start...

> Check the `t/config/data-sources.xml` file to make sure the
> connection parameters for the `bedrock` database match your
> environment.

Note that the [`create-session.sql`](src/main/bedrock/create-session.sql) script
will perform all of these steps. __CAUTION:__ the script will drop
your `bedrock` database if it exists!

1. Create the database and session table
   ```
   cd src/main/perl
   mysqladmin -u root create bedrock
   cat ../bedrock/mysql-session.sql | mysql -u root bedrock
   ```
1. Grant user `fred` privileges. Test will be run with user=`fred`,
password=`flintstone`.
   ```
   create user 'fred'@'localhost' identified by 'flintstone'
   grant all on *.* to 'fred'@'localhost';
   ```
1. Run the tests.
   ```
   TEST=all make test
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
