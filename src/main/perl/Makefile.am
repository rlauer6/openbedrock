#-*- mode: makefile; -*-

SUBDIRS = lib bin cgi-bin .

TEST_LOG_DRIVER = env AM_TAP_AWK='$(AWK)' $(SHELL) \
              $(top_srcdir)/autotools/tap-driver.sh

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
    t/14-flush.yml \
    t/15-include.yml

BEDROCK_SQL_TESTS = \
    t/12-sqlconnect.yml \
    t/13-sql.yml

BEDROCK_TEST_HARNESS = \
    lib/Test/Bedrock.pm.in

@do_subst_command@

%.pm: %.pm.in
	test -d "$$(dirname "$@")" || $(INSTALL) -d "$$(dirname "$@")"
	$(do_subst) $< > $@

# NOTE:
#
# Each test is represented by a .yml (YAML) file. We create a symbolic
# link for each .yml file of the form t/test.t to the generic
# `test.tag.pl`.  This script figures out which test to run based on
# the basename of the test being executed.  Accordingly because we
# create the symbolic links to a test directory so we are only saving
# the .yml files to the project
#
# See `perldoc lib/Test/Bedrock.pm` for more information about
# creating Bedrock tests.

GBEDROCK_TEST_HARNESS = $(BEDROCK_TEST_HARNESS:.pm.in=.pm)

harness: $(GBEDROCK_TEST_HARNESS)

#.PHONY: test
test: $(BEDROCK_TESTS) $(GBEDROCK_TEST_HARNESS)
	cd lib;
	$(MAKE)
	if test -z "$$DBI_SOCKET"; then \
	  if test -e '/tmp/mysqld/mysqld.sock'; then \
	     DBI_SOCKET=/tmp/mysqld/mysqld.sock; \
	  fi; \
	fi; \
	TESTS=$$TESTS; \
	if test -z "$$TESTS"; then \
	  TESTS="$(BEDROCK_TESTS)"; \
	elif [ "$$TESTS" = "all" ]; then \
	  TESTS="$(BEDROCK_TESTS) $(BEDROCK_SQL_TESTS)"; \
	elif [ "$$TESTS" = "sql" ]; then \
	  TESTS="$(BEDROCK_SQL_TESTS)"; \
	else \
	  echo "TESTS: $$TESTS"; \
	fi; \
	test_dir=$$(mktemp -d); \
	mkdir $$test_dir/t; \
	for a in $$TESTS; do \
	  test_file=$$(basename $$a .yml); \
	  ln -s $(abs_srcdir)/test-tag.pl $$test_dir/t/$$test_file.t; \
	done; \
	DBI_SOCKET="$$DBI_SOCKET" CONFIG_PATH=$(top_srcdir)/src/main/bedrock/config:. $(PROVE) -v -I lib/ -I lib/Bedrock -I lib/Bedrock/Text $$test_dir/t; \
	test -n "$$test_dir" && rm -rf "$$test_dir"

CLEANFILES = \
    foo.inc \
    foo.txt \
    bedrock-page-log.txt

