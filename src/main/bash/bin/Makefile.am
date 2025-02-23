SUBDIRS = .

bashrun = @BASHRUN@

@do_subst_command@

BASHSCRIPTS = \
    bedrock-install-plugin.sh.in

GBASHSCRIPTS = $(BASHSCRIPTS:.in=)

dist_noinst_DATA = \
    $(BASHSCRIPTS)

bin_SCRIPTS = \
    $(GBASHSCRIPTS)

$(GBASHSCRIPTS): % : %.in
	$(do_subst) $< > $@
	chmod +x $@

CLEANFILES = \
    $(GBASHSCRIPTS)

all:
