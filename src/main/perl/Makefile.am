## Process this file with automake to produce Makefile.in   -*-Makefile-*-

SUBDIRS = \
    lib     \
    bin     \
    cgi-bin \
    .

TESTS = \
    t/flush.txt   \
    t/if.txt      \
    t/include.txt \
    t/null.txt    \
    t/open.txt    \
    t/plugin.txt  \
    t/reftype.txt  \
    t/sink.txt    \
    t/try.txt     \
    t/var.txt

# each test is represented by a .txt (YAML) file we create a symbolic
# link for eacth .txt file of the form t/test.t to the generic
# test.tag.pl file which figures out which test to run based on the
# basename of the test being executed.  Accordingly we create the
# symbolic links to a test directory so we are only saving the .txt
# files to the project

test:
	test_dir=$$(mktemp -d); \
	mkdir $$test_dir/t; \
	for a in $(TESTS); do \
	  test_file=$$(basename $$a .txt); \
	  ln -s $(abs_srcdir)/test-tag.pl $$test_dir/t/$$test_file.t; \
	done; \
	$(PROVE) -v -I lib/ -I lib/Bedrock -I lib/Bedrock/Text $$test_dir/t; \
	test -n "$$test_dir" && rm -rf "$$test_dir"
