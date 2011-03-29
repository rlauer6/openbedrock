SUBDIRS = .

PERL = @PERL@

@do_subst_command@

PERLSCRIPTS = \
    bedrock.pl.in

GPERLSCRIPTS = $(PERLSCRIPTS:.pl.in=)

dist_noinst_DATA = $(PERLSCRIPTS)

bin_SCRIPTS = $(GPERLSCRIPTS)

$(GPERLSCRIPTS): $(PERLSCRIPTS)
	$(do_subst) $< > $@

CLEANFILES = $(GPERLSCRIPTS)
