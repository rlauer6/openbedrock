# README

This is the README for the Bedrock Perl module test suite. This is currently
a work-in-progress since unit tests were not created when the project
began. There are many untested features of Bedrock so new tests __should__
be added whenever code is refactored or bugs are found.

The intent of these particular tests is to specific Perl modules that
are used by Bedrock. Tag testing is done with the test framework found
in `src/main/perl`.

The majority of the tests currently created are primarly designed to
test the Perl modules involved in database access. There are three
groups of tests used to exercise these modules:

| Module | Test Group |
| ------ | ----- |
| `BLM::DBHandler` | `t/xx-dbhandler.t` |
| `BLM::IndexedTableHandler` | `t/xx-indexedtablehandler.t`
| `Bedrock::Model::*` | `t/xx-model.t` |

# Test Requirements

To test the modules you need to have a MySQL server available. If you
have used the Docker image created by the `Dockerfile` in the `docker`
directory to launch an Apache web server running Bedrock it would have
also launched a MySQL server. You can then run all of the tests in the
`t/' directory like this:

```
cd src/main/perl/lib
make test
```

The `Makefile.am` and the test harness use the settings in the table
below as the defaults. To specify a different server and use custom
connection parameters, set environment variables as shown below:

| Environment Variable | Description | Default |
| -------------------- | ----- |
| `DBI_HOST` | Name of the MySQL host | `localhost` |
| `DBI_USER` | username | `root` |
| `DBI_PASS` | password | `bedrock` |
| `DBI_DB` | database name  | none |
| `DBI_SOCKET` | socket path | none |

The database connection for every test that involves using a MySQL
server `requires` the Perl module `t/db-setup.pl`. 

This module includes a subroutine named `connect_db` which creates the
datasebase handle passed to the module being tested.

# Testing a Single Group

A group of tests all have the same filename with a prefix of an
integer that determines the order in which that group of tests will be
executed.  You can execute a subset of the unit tests by setting the
environment variable `TEST` to the group name.

```
TEST=indexedtablehanlder make test
```
