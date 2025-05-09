SUBDIRS = . bedrock-lite

CPAN_DIST_MAKER = make-cpan-dist.pl

PACKAGE_VERSION = @PACKAGE_VERSION@

TARBALL = $(builddir)/Bedrock-$(PACKAGE_VERSION).tar.gz

REQUIRES_FILE = $(srcdir)/requires
TEST_REQUIRES_FILE = $(srcdir)/test-requires

all:

.PHONY: cpan
cpan: $(TARBALL)

if RPMBUILD_ENABLED
$(TARBALL):
	touch $@
else
$(TARBALL): buildspec.yml
	if test -z "$(DESTDIR)"; then \
	  tmpdir=$$(mktemp -d); \
	  project_root="$${tmpdir}/usr"; \
	  $(MAKE) -C $(top_builddir) prefix=/usr install DESTDIR=$$tmpdir; \
	else \
	  project_root="$(DESTDIR)/usr"; \
	fi; \
	test -n "$$DEBUG" && set -x; \
	test -n "$$DEBUG" && DEBUG="--debug"; \
	REQUIRES="-r $$project_root/share/bedrock/requires"; \
	test -n "$(NOCLEANUP)" && NOCLEANUP="--no-cleanup"; \
	test -n "$(DRYRUN)" && DRYRUN="--dryrun"; \
	test -n "$(SCANDEPS)" && SCANDEPS="-s"; \
	test -n "$(NOVERSION)" && NOVERSION="-n"; \
	PROJECT_ROOT="--project-root $$project_root"; \
	SKIP_TESTS=1 \
	$(CPAN_DIST_MAKER) $$PROJECT_ROOT $$REQUIRES \
	  $$DRYRUN $$SCANDEPS $$NOVERSION $$NOCLEANUP $$DEBUG -b $< || true; \
	test -e $(TARBALL) || false; \
	if test -n "$$tmpdir"; then \
	  echo "rm -rf $$tmpdir"; \
	fi
endif

cpandir = $(datadir)/bedrock

dist_cpan_DATA = \
    requires \
    test-requires \
    buildspec.yml \
    postamble

CLEANFILES = \
    extra-files \
    provides \
    resources 

clean-local:
	for a in $(CLEANFILES); do \
	  rm -f $$a || true; \
	done
	rm -f *.tar.gz
	rm -f *.tmp
