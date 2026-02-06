SUBDIRS = .

ax_perl5_extra_includes = @ax_perl5_extra_includes@

apache_layout = @apache_layout@

VERSION = @VERSION@

MYSQL_HOST     = @mysql_host@
MYSQL_DATABASE = @mysql_database@
MYSQL_USER     = @mysql_user@
MYSQL_PASSWORD = @mysql_password@

APACHE_ENV_FILES = \
    apache24-env-debian.in \
    apache22-env-debian.in \
    apache24-env-redhat.in \
    apache22-env-redhat.in

GAPACHE_ENV_FILES = $(APACHE_ENV_FILES:.in=)

$(GAPACHE_ENV_FILES): % : %.in
	$(do_subst) $< > $@

EXTRA_FILES = \
    bedrock.users \
    site-config.inc \
    miniserver-schema.json

ROC_FILES= \
    bedrock.conf.roc \
    bedrock-session-files.conf.roc \
    bedrock-autocomplete.conf.roc \
    bedrock-manifest.roc \
    data-sources.xml.roc \
    dbi.conf.roc \
    default_form_config.json.roc \
    mysql-session.xml.roc \
    tagx.xml.roc

@do_subst_command@

ADMIN = \
    admin/index.roc \
    admin/bedrock.css \
    admin/bedrock.js \
    admin/handler.inc \
    admin/register-container.inc \
    admin/login-container.inc \
    admin/plugins-container.inc \
    admin/register.roc

admindir = $(configdir)/admin

dist_admin_DATA = $(ADMIN)

CONFIG = \
    bedrock.xml.in \
    bedrock-rest-framework.conf.in \
    data-sources.xml.in \
    mysql-session.xml.in \
    rest.xml.in \
    pod_paths.xml.in \
    markdown_paths.xml.in \
    startup.pl.in \
    tagx.xml.in \
    tagx_apps.xml.in

CONF_FILES = \
    log4perl.conf \
    bedrock-docs.yml \
    bedrock-miniserver.yml

GCONFIG = $(CONFIG:.in=)

$(GCONFIG): % : %.in
	$(do_subst) $< > $@

config_DATA = \
    $(GCONFIG) \
    $(EXTRA_FILES) \
    $(ROC_FILES) \
    $(GAPACHE_ENV_FILES)

dist_config_DATA = \
    $(EXTRA_FILES) \
    $(CONF_FILES) \
    $(ROC_FILES) \
    $(APACHE_ENV_FILES)

dist_noinst_DATA = $(CONFIG)

all: 

CLEANFILES = $(GCONFIG) $(GAPACHE_ENV_FILES)
