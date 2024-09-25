SUBDIRS = .

ax_perl5_extra_includes = @ax_perl5_extra_includes@

VERSION = @VERSION@

EXTRA_FILES = \
    bedrock.users \
    apache24-env-debian \
    apache22-env-debian \
    apache24-env-redhat \
    apache22-env-redhat \
    site-config.inc \
    httpd-bedrock.conf.roc

@do_subst_command@

CONFIG = \
    bedrock-rest-framework.conf.in \
    data-sources.xml.in \
    mysql-session.xml.in \
    perl_bedrock.conf22.in \
    perl_bedrock.conf24.in \
    redis-cache.xml.in \
    redis-session.xml.in \
    rest.xml.in \
    pod_paths.xml.in \
    markdown_paths.xml.in \
    startup.pl.in \
    tagx.xml.in \
    tagx_apps.xml.in

CONFFILES = \
    log4perl.conf

GCONFIG = $(CONFIG:.in=)

$(GCONFIG): % : %.in
	$(do_subst) $< > $@

config_DATA = $(GCONFIG) $(EXTRA_FILES)

dist_config_DATA = $(EXTRA_FILES) $(CONFFILES)

dist_noinst_DATA = $(CONFIG)

all: 

CLEANFILES = $(GCONFIG)
