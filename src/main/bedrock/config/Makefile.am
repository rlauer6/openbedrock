SUBDIRS = .

ax_perl5_extra_includes = @ax_perl5_extra_includes@

VERSION = @VERSION@

@do_subst_command@

CONFIG = \
    tagx.xml.in \
    tagx_apps.xml.in \
    perl_bedrock.conf.in \
    bedrock-rest-framework.conf.in \
    startup.pl.in

GCONFIG = $(CONFIG:.in=)

$(GCONFIG): % : %.in
	$(do_subst) $< > $@

config_DATA = $(GCONFIG)

dist_config_DATA = bedrock.users

dist_noinst_DATA = $(CONFIG)

all: 

CLEANFILES = $(GCONFIG)
