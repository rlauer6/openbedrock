SUBDIRS = .

ax_perl5_extra_includes = @ax_perl5_extra_includes@

VERSION = @VERSION@

EXTRA_FILES = \
    bedrock.users \
    apache24-env-debian \
    apache22-env-debian \
    apache24-env-redhat \
    apache22-env-redhat \
    site-config.inc

ROC_FILES= \
    bedrock.conf.roc \
    bedrock-manifest.roc \
    dbi.conf.roc \
    default_form_config.json.roc \
    mysql-session.xml.roc \
    tagx.xml.roc

@do_subst_command@

ADMIN = \
    admin/index.roc \
    admin/bedrock.css \
    admin/bedrock.js

admindir = $(configdir)/admin

dist_admin_DATA = $(ADMIN)

CONFIG = \
    bedrock.xml.in \
    bedrock-rest-framework.conf.in \
    data-sources.xml.in \
    mysql-session.xml.in \
    perl_bedrock.conf22.in \
    perl_bedrock.conf24.in \
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

config_DATA = $(GCONFIG) $(EXTRA_FILES) $(ROC_FILES)

dist_config_DATA = $(EXTRA_FILES) $(CONFFILES) $(ROC_FILES)

dist_noinst_DATA = $(CONFIG)

all: 

CLEANFILES = $(GCONFIG)
