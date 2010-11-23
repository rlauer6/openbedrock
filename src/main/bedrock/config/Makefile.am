SUBDIRS = .

@do_subst_command@

CONFIG = \
    tagx.xml.in \
    tagx_apps.xml.in \
    bedrock.conf.in \
    startup.pl.in

GCONFIG = $(CONFIG:.in=)

$(GCONFIG): % : %.in
	$(do_subst) $< > $@

config_DATA = $(GCONFIG)

dist_noinst_DATA = $(CONFIG)

all: 

CLEANFILES = $(GCONFIG)
