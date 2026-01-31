SUBDIRS = .

perl5_pkglibdir = @perl5_pkglibdir@

perlrun = @PERL@

if RPMBUILD_ENABLED
perlwc = \#
else
perlwc = @PERL@ -wc
endif

@do_subst_command@

POD2MAN = /usr/bin/pod2man

PERLSCRIPTS = \
    bedrock.pl.in \
    bedrock-dist.pl.in \
    bedrock-plugin.pl.in \
    bedrock-miniserver.pl.in \
    bedrock-model.pl.in \
    bedrock-lsp.pl.in \
    bedrock-model-importer.pl.in \
    bedrock-cache.pl.in \
    brxml2json.pl.in \
    bedrock-site-install.pl.in \
    dnky-config.pl.in \
    create-sqlite-session-table.pl.in

GPERLSCRIPTS = $(PERLSCRIPTS:.pl.in=.pl)

G1MANPAGES = $(GPERLSCRIPTS:.pl=.1bedrock)

dist_noinst_DATA = $(PERLSCRIPTS)

bin_SCRIPTS = $(GPERLSCRIPTS)

man1_MANS = $(G1MANPAGES)

$(GPERLSCRIPTS): % : %.in 
	$(do_subst) $< > $@
	libdir=$(abs_builddir)/../lib; \
	$(perlwc) -I $$libdir -I $$libdir/Bedrock -I $$libdir/Bedrock/Text $@
	chmod +x $@

CLEANFILES = $(GPERLSCRIPTS) $(GMANPAGES)

$(G1MANPAGES): %.1bedrock : %.pl
	target_name="$@";\
	tname=$$(echo "$${target_name}" | sed -e 's/\.1bedrock$$//') ;\
	"$(POD2MAN)" $< \
	--center='Bedrock' \
	--name="$${tname}" \
	--release=$(PACKAGE_VERSION) \
	--section=1bedrock > "$${target_name}" || true

install-data-hook: installdirs
	test -e $(DESTDIR)/bin || mkdir $(DESTDIR)/bin
	ln -f -s ../usr/bin/bedrock.pl  $(DESTDIR)/bin/bedrock
	ln -f -s bedrock-model.pl  $(DESTDIR)/$(bindir)/bedrock-model
	ln -f -s bedrock-site-install.pl  $(DESTDIR)/$(bindir)/bedrock-site-install
	ln -f -s create-sqlite-session-table.pl  $(DESTDIR)/$(bindir)/create-sqlite-session-table
	ln -f -s bedrock-plugin.pl  $(DESTDIR)$(bindir)/bedrock-plugin
	ln -f -s bedrock-model-importer.pl  $(DESTDIR)$(bindir)/bedrock-model-importer
	ln -f -s dnky-config.pl $(DESTDIR)$(bindir)/dnky-config

.PHONY: clean-local
clean-local:
	$(MAKE) clean-generated-man-pages

.PHONY: clean-generated-man-pages
clean-generated-man-pages:
	for mpath in $(G1MANPAGES); do \
	rm -f "$${mpath}" ;\
	test $$? -eq 0 || exit 1 ;\
	done
