#-*- mode: makefile; -*-

SUBDIRS = lib bin cgi-bin .

check_SCRIPTS = bedrock-test

TESTS = $(check_SCRIPTS)

TEST_LOG_DRIVER = env AM_TAP_AWK='$(AWK)' $(SHELL) \
              $(top_srcdir)/autotools/tap-driver.sh

BEDROCK_TESTS = \
    t/00-var.yml \
    t/00-chomp.yml \
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
    t/15-include.yml \
    t/16-case.yml \
    t/17-array.yml \
    t/18-hash.yml \
    t/19-pebble.yml \
    t/20-benchmark.yml \
    t/22-include.yml \
    t/27-replace.yml \
    t/28-matches.yml

BEDROCK_CACHE_TESTS = \
    t/24-cache.yml \
    t/25-sink-cache.yml \
    t/26-var-cache.yml

BEDROCK_MAIL_TESTS = \
    t/23-mail.yml

BEDROCK_SQL_TESTS = \
    t/12-sqlconnect.yml \
    t/13-sql.yml \
    t/21-sqlselect.yml

BEDROCK_TEST_HARNESS = \
    lib/Bedrock/Test.pm.in \
    lib/Bedrock/Test/Utils.pm.in

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

.PHONY: test
test: $(BEDROCK_TESTS) $(GBEDROCK_TEST_HARNESS) bedrock-test
	set -x; \
	TEST=$$TEST ./run-tests test-list . .
	rm -f test-list

test-list:
	set -x; \
	echo $$TEST; \
	TEST=$$TEST; \
	if test -z "$$TEST"; then \
	  TEST="$(BEDROCK_TESTS)"; \
	elif [ "$$TEST" = "all" ]; then \
	  TEST="$(BEDROCK_TESTS) $(BEDROCK_SQL_TESTS) $(BEDROCK_MAIL_TESTS) $(BEDROCK_CACHE_TESTS)"; \
	elif [ "$$TEST" = "cache" ]; then \
	  TEST="$(BEDROCK_CACHE_TESTS)"; \
	elif [ "$$TEST" = "mail" ]; then \
	  TEST="$(BEDROCK_MAIL_TESTS)"; \
	elif [ "$$TEST" = "sql" ]; then \
	  TEST="$(BEDROCK_SQL_TESTS)"; \
	else \
	  if ! test -e "$$TEST"; then \
	    set -x; \
	    TEST_LIST="$$TEST"; \
	    TEST=""; \
	    for a in $$TEST_LIST; do \
	      echo "a = $$a"; \
	      T=$$(find $(srcdir)/t/ -name "*$${a}.yml" -print -quit 2>/dev/null); \
	      test -n "$$T" && TEST="$$TEST $$T"; \
	    done; \
	    if test -z "$$TEST"; then \
	      >&2 echo "no such test"; \
	      exit 1; \
	    fi; \
	  fi; \
	fi; \
	echo $$TEST > $@

.PHONY: bedrock-test
bedrock-test: test-list
	$(MAKE)
	echo "$(srcdir)/run-tests test-list $(srcdir) $(builddir)" > bedrock-test
	chmod 755 bedrock-test

testsdir = $(datadir)/bedrock/tests/perl

dist_tests_DATA = \
    $(BEDROCK_TESTS) \
    run-tests

CLEANFILES = \
    foo.inc \
    foo.txt \
    bedrock-page-log.txt \
    test-list \
    bedrock-test
