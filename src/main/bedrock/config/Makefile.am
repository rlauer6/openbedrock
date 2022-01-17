SUBDIRS = .

ax_perl5_extra_includes = @ax_perl5_extra_includes@

VERSION = @VERSION@

@do_subst_command@

CONFIG = \
    tagx.xml.in \
    mysql-session.xml.in \
    tagx_apps.xml.in \
    perl_bedrock.conf22.in \
    perl_bedrock.conf24.in \
    bedrock-rest-framework.conf.in \
    startup.pl.in

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
