SUBDIRS = .

perl5_pkglibdir = @perl5_pkglibdir@

PERL = @PERL@

@do_subst_command@

PERLSCRIPTS = \
    bedrock.pl.in \
    bedrock-plugin.pl.in

GPERLSCRIPTS = $(PERLSCRIPTS:.pl.in=)

dist_noinst_DATA = $(PERLSCRIPTS)

bin_SCRIPTS = $(GPERLSCRIPTS)

$(GPERLSCRIPTS): % : %.pl.in 
	$(do_subst) $< > $@
	perl -wc -I $(abs_builddir)/../lib $@

CLEANFILES = $(GPERLSCRIPTS)

if DISTCHECK_HACK_ENABLED
else
install-data-hook:
	ln -f -s @bindir@/bedrock /bin/bedrock
endif
