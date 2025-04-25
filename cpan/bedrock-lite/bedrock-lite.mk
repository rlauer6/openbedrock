#-*- mode:makefile; -*-
CPAN_DIST_MAKER = make-cpan-dist.pl

PACKAGE_VERSION = @PACKAGE_VERSION@

TARBALL = Bedrock-Lite-$(PACKAGE_VERSION).tar.gz

LIB_PACKAGE_MODULES = $(addprefix $(top_builddir)/src/main/perl/,$(PACKAGE_MODULES))

$(PACKAGE_MODULES): $(builddir)/%: $(top_builddir)/src/main/perl/%
	@test -d $(builddir)/$$(dirname $@) || mkdir -p $(builddir)/$$(dirname $@)
	@src=$(top_builddir)/src/main/perl/$@; \
	perl -MPod::Strip -e '$$s=Pod::Strip->new; $$s->parse_from_file($$ARGV[0])' $$src > $(builddir)/$@

BIN_PACKAGE_EXE = $(addprefix $(top_srcdir)/src/main/perl/,$(PACKAGE_EXE))

$(PACKAGE_EXE): $(builddir)/%: $(top_srcdir)/src/main/perl/%
	test -d $(builddir)/$$(dirname $@) || mkdir -p $(builddir)/$$(dirname $@)
	cp $(top_builddir)/src/main/perl/$@ $(builddir)/$@
	chmod +x $(builddir)/$@

EXTRA_FILES = \
   t/00-bedrock.t \
   requires \
   test-requires

PACKAGE_EXTRA_FILES = $(addprefix $(builddir)/,$(EXTRA_FILES))

.PHONY: extra-files
extra-files:
	for a in $(EXTRA_FILES); do \
	  test -d $(builddir)/$$(dirname $$a) || mkdir -p $(builddir)/$$(dirname $$a); \
	  test -e $(builddir)/$$a || cp $(srcdir)/$$(basename $$a).in $(builddir)/$$a; \
	done

BEDROCK_LITE_DEPS = \
    buildspec.yml \
    lib/Bedrock/Lite.pm \
    $(PACKAGE_MODULES) \
    extra-files

.PHONY: cpan
cpan: $(BEDROCK_LITE_DEPS)
	test -n "$$DEBUG" && set -x; \
	test -n "$$DEBUG" && DEBUG="--debug"; \
	test -e requires && REQUIRES="-r requires"; \
	test -n "$(NOCLEANUP)" && NOCLEANUP="--no-cleanup"; \
	test -n "$(DRYRUN)" && DRYRUN="--dryrun"; \
	test -n "$(SCANDEPS)" && SCANDEPS="-s"; \
	test -n "$(NOVERSION)" && NOVERSION="-n"; \
	PROJECT_ROOT="--project-root $$(readlink -f "$(PROJECT_ROOT)")"; \
	SKIP_TESTS=1 \
	$(CPAN_DIST_MAKER) $$PROJECT_ROOT $$REQUIRES $$DRYRUN \
	   $$SCANDEPS $$NOVERSION $$NOCLEANUP $$DEBUG -b $< || false

CLEANFILES = \
    extra-files \
    provides \
    resources \
    $(PACKAGE_MODULES) \
    $(PACKAGE_EXTRA_FILES)

clean-local:
	for a in $(CLEANFILES); do \
	  rm -f $$a || true; \
	done
	rm -f *.tar.gz
	rm -f *.tmp
