SUBDIRS = .

ax_perl5_extra_includes = @ax_perl5_extra_includes@

VERSION = @VERSION@

@do_subst_command@

CONFIG = \
    bedrock-rest-framework.conf.in \
    data-sources.xml.in \
    mysql-session.xml.in \
    perl_bedrock.conf22.in \
    perl_bedrock.conf24.in \
    startup.pl.in \
    tagx.xml.in \
    tagx_apps.xml.in

CONFFILES = \
    log4perl.conf

GCONFIG = $(CONFIG:.in=)

$(GCONFIG): % : %.in
	$(do_subst) $< > $@

config_DATA = $(GCONFIG)

dist_config_DATA = bedrock.users $(CONFFILES)

dist_noinst_DATA = $(CONFIG)

all: 

CLEANFILES = $(GCONFIG)
