#-*- mode:makefile; -*-
CPAN_DIST_MAKER = make-cpan-dist.pl

PACKAGE_VERSION = @PACKAGE_VERSION@

TARBALL = Bedrock-Core-$(PACKAGE_VERSION).tar.gz

EXTRA_FILES = \
   requires \
   test-requires \
   postamble

CONFIG_FILES = \
   bedrock-rest-framework.conf \
   bedrock.xml \
   data-sources.xml \
   log4perl.conf \
   mysql-session.xml \
   rest.xml \
   s3.xml \
   tagx_apps.xml \
   tagx.xml

tmpdir := $(shell mktemp -d)

.PHONY: cpan
cpan: $(TARBALL)

# note Bedrock::Core is a fabricated module from Bedrock.pm
$(TARBALL): buildspec.yml
	$(MAKE) -C $(top_builddir) prefix=/usr install DESTDIR=$(tmpdir)
	trap 'rm -rf "$(tmpdir)"' EXIT INT TERM HUP; \
	project_root="$(tmpdir)/usr"; \
	install_files=$$(mktemp); \
	include_files=$$(mktemp); \
	cat <(echo -e "package Bedrock::Core;\n\nour \$$VERSION='$(PACKAGE_VERSION)';\n\n") $$project_root/share/perl5/Bedrock.pm > $$project_root/share/perl5/Bedrock/Core.pm; \
	cp $$project_root/bin/bedrock.pl $$project_root/bin/bedrock; \
	chmod +x $$project_root/bin/bedrock; \
	find "$$project_root" -type f | sort > $$install_files; \
	for a in $(PACKAGE_MODULES); do \
	  echo "$$project_root/share/perl5/$$a" >>$$include_files; \
	done; \
	for a in $(SHELL_MODULES); do \
	  echo "$$project_root/share/perl5/$$a" >>$$include_files; \
	done; \
	for a in $(PACKAGE_EXE); do \
	  echo "$$project_root/$$a" >>$$include_files; \
	done; \
	for a in $(CONFIG_FILES); do \
	  echo "$$project_root/share/bedrock/config/$$a" >>$$include_files; \
	done; \
	for a in $(EXTRA_FILES); do \
	  cp $$a "$$project_root/share/bedrock/$$a"; \
	  echo "$$project_root/share/bedrock/$$a" >>$$include_files; \
	done; \
	for a in $(ALL_TESTS); do \
	  test -e "$$project_root/share/bedrock/tests/perl/$$a"; \
	  echo "$$project_root/share/bedrock/tests/perl/$$a" >>$$include_files; \
	done; \
	echo $$project_root/share/bedrock/tests/perl/bedrock-runner.pl >>$$include_files; \
	include_files_sorted=$$(mktemp); \
	sort -u $$include_files > $$include_files_sorted; \
	comm -23 $$install_files $$include_files_sorted | xargs -r rm -f; \
	rm $$install_files; \
	rm $$include_files; \
	rm $$include_files_sorted; \
	test -n "$$DEBUG" && set -x; \
	test -n "$$DEBUG" && DEBUG="--debug"; \
	test -e requires && REQUIRES="-r requires"; \
	test -n "$(NOCLEANUP)" && NOCLEANUP="--no-cleanup"; \
	test -n "$(DRYRUN)" && DRYRUN="--dryrun"; \
	test -n "$(SCANDEPS)" && SCANDEPS="-s"; \
	test -n "$(NOVERSION)" && NOVERSION="-n"; \
	PROJECT_ROOT="--project-root $$(readlink -f "$$project_root")"; \
	SKIP_TESTS="$${SKIP_TESTS:-1}" \
	$(CPAN_DIST_MAKER) $$PROJECT_ROOT $$REQUIRES $$DRYRUN \
	   $$SCANDEPS $$NOVERSION $$NOCLEANUP $$DEBUG -b $< || false

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
