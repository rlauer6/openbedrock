## Process this file with automake to produce Makefile.in   -*-Makefile-*-
SUBDIRS = \
    lib     \
    bin     \
    cgi-bin \
    .

check_SCRIPTS = prove.sh

TESTS = $(check_SCRIPTS)

TEST_LOG_DRIVER = env AM_TAP_AWK='$(AWK)' $(SHELL) \
              $(top_srcdir)/autotools/tap-driver.sh

BEDROCK_TESTS = \
    t/flush.yml   \
    t/if.yml      \
    t/iif.yml      \
    t/include.yml \
    t/null.yml    \
    t/open.yml    \
    t/plugin.yml  \
    t/reftype.yml  \
    t/sink.yml    \
    t/sqlconnect.yml    \
    t/try.yml     \
    t/var.yml

# each test is represented by a .yml (YAML) file we create a symbolic
# link for eacth .yml file of the form t/test.t to the generic
# test.tag.pl file which figures out which test to run based on the
# basename of the test being executed.  Accordingly we create the
# symbolic links to a test directory so we are only saving the .yml
# files to the project

test:
	test_dir=$$(mktemp -d); \
	mkdir $$test_dir/t; \
	for a in $(BEDROCK_TESTS); do \
	  test_file=$$(basename $$a .yml); \
	  ln -s $(abs_srcdir)/test-tag.pl $$test_dir/t/$$test_file.t; \
	done; \
	$(PROVE) -v -I lib/ -I lib/Bedrock -I lib/Bedrock/Text $$test_dir/t; \
	test -n "$$test_dir" && rm -rf "$$test_dir"

prove.sh:
	test_dir=$$(mktemp -d); \
	mkdir $$test_dir/t; \
	for a in $(BEDROCK_TESTS); do \
	  test_file=$$(basename $$a .yml); \
	  ln -s $(abs_srcdir)/test-tag.pl $$test_dir/t/$$test_file.t; \
	done; \
	echo "$(PROVE) -v -I lib/ -I lib/Bedrock -I lib/Bedrock/Text $$test_dir/t" > prove.sh
	chmod 755 prove.sh

CLEANFILES = \
    prove.sh
