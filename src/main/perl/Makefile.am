#-*- mode: makefile; -*-

SUBDIRS = lib bin cgi-bin .

TEST_LOG_DRIVER = env AM_TAP_AWK='$(AWK)' $(SHELL) \
              $(top_srcdir)/autotools/tap-driver.sh

BEDROCK_TESTS = \
    t/flush.yml \
    t/foreach.yml \
    t/if.yml \
    t/iif.yml \
    t/include.yml \
    t/null.yml \
    t/open.yml \
    t/plugin.yml \
    t/reftype.yml \
    t/multi-line.yml \
    t/sink.yml \
    t/snippet.yml \
    t/sqlconnect.yml \
    t/sql.yml \
    t/try.yml \
    t/var.yml

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

#.PHONY: test
test: $(BEDROCK_TESTS) $(BEDROCK_TEST_HARNESS:.pm.in=.pm)
	cd lib;
	$(MAKE)
	TESTS=$$TESTS; \
	if test -z "$$TESTS"; then \
	  TESTS="$(BEDROCK_TESTS)"; \
	else \
	  echo "TESTS: $$TESTS"; \
	fi; \
	test_dir=$$(mktemp -d); \
	mkdir $$test_dir/t; \
	for a in $$TESTS; do \
	  test_file=$$(basename $$a .yml); \
	  ln -s $(abs_srcdir)/test-tag.pl $$test_dir/t/$$test_file.t; \
	done; \
	CONFIG_PATH=config $(PROVE) -v -I lib/ -I lib/Bedrock -I lib/Bedrock/Text $$test_dir/t; \
	test -n "$$test_dir" && rm -rf "$$test_dir"
