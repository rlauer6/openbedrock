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
    bedrock-plugin.pl.in \
    bedrock-model.pl.in \
    bedrock-model-importer.pl.in \
    bedrock-cache.pl.in \
    brxml2json.pl.in

GPERLSCRIPTS = $(PERLSCRIPTS:.pl.in=.pl)

G1MANPAGES = $(GPERLSCRIPTS:.pl=.1bedrock)

dist_noinst_DATA = $(PERLSCRIPTS)

bin_SCRIPTS = $(GPERLSCRIPTS)

man1_MANS = $(G1MANPAGES)

$(GPERLSCRIPTS): % : %.in 
	$(do_subst) $< > $@
	$(perlwc) -I $(abs_builddir)/../lib $@
	chmod +x $@

CLEANFILES = $(GPERLSCRIPTS) $(GMANPAGES)

$(G1MANPAGES): %.1bedrock : %.pl
	target_name="$@";\
	tname=$$(echo "$${target_name}" | sed -e 's/\.1bedrock$$//') ;\
	"$(POD2MAN)" $< \
	--center='Bedrock' \
	--name="$${tname}" \
	--release=$(PACKAGE)-$(VERSION) \
	--section=1bedrock > "$${target_name}"

if DISTCHECK_HACK_ENABLED
else
install-data-hook: installdirs
	test -e $(DESTDIR)/bin || mkdir $(DESTDIR)/bin
	ln -f -s @bindir@/bedrock.pl  $(DESTDIR)/bin/bedrock
	ln -f -s @bindir@/bedrock-model.pl  $(DESTDIR)/$(bindir)/bedrock-model
	ln -f -s @bindir@/bedrock-plugin.pl  $(DESTDIR)$(bindir)/bedrock-plugin
	ln -f -s @bindir@/bedrock-model-importer.pl  $(DESTDIR)$(bindir)/bedrock-model-importer
endif

.PHONY: clean-local
clean-local:
	$(MAKE) clean-generated-man-pages

.PHONY: clean-generated-man-pages
clean-generated-man-pages:
	for mpath in $(G1MANPAGES); do \
	rm -f "$${mpath}" ;\
	test $$? -eq 0 || exit 1 ;\
	done
