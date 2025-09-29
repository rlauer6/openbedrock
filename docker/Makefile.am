SUBDIRS = .
#-*- mode: makefile; -*-

@do_subst_command@

TARBALL = $(builddir)/Bedrock-$(PACKAGE_VERSION).tar.gz

TARBALL_CORE = $(builddir)/Bedrock-Core-$(PACKAGE_VERSION).tar.gz 

all: env config apache2.conf bedrock.md5sum

.PHONY: images
images: bedrock.md5sum $(TARBALL) $(TARBALL_CORE) $(ENV_FILES) apache2.conf $(CONFIG_FILES)

MYSQL_HOST          = @mysql_host@
MYSQL_PASSWORD      = @mysql_password@
MYSQL_ROOT_PASSWORD = @mysql_root_password@
MYSQL_USER          = @mysql_user@
MYSQL_DATABASE      = @mysql_database@

.PHONY: config
config: $(CONFIG_FILES)

.PHONY: env
env: $(ENV_FILES)

########################################################################
# generic pattern rules
########################################################################
%: %.in
	$(do_subst) $< > $@

ACCESS_LOG := $(shell \
  if [ -n "$$STREAM_LOGS" ]; then \
    echo /dev/fd/1; \
  else \
    echo /var/www/log/access_log; \
  fi)

ERROR_LOG := $(shell \
  if [ -n "$$STREAM_LOGS" ]; then \
    echo /dev/fd/1; \
  else \
    echo /var/www/log/error_log; \
  fi)

%.conf: %.conf.in
	$(do_subst) $< | \
	sed -e 's,@error_log@,'$(ERROR_LOG)',' \
	    -e 's,@access_log@,'$(ACCESS_LOG)',' \
	    -e 's,\@PACKAGE_VERSION\@,'@PACKAGE_VERSION@',' > $@

########################################################################
# CONFIG_FILES, CLEAN_FILES will be incrementally added to in *.mk sections
########################################################################
CONFIG_FILES = 
CLEANFILES  =

########################################################################
# MySQL server certificates for Docker (not used for mysql >8.3)
########################################################################
include mysql-certs.mk

########################################################################
# Bedrock
########################################################################
include bedrock.mk

########################################################################
# Docker
########################################################################
include docker.mk

########################################################################
# Github - create the CI build image and push to ghcr.io
#
# make bedrock-ci
########################################################################
include github.mk

########################################################################
# Dockerhub - push tagged images to Dockerhub
#
# make public-{ostype}
########################################################################
REPO ?= rlauer/openbedrock
DOCKERHUB_TOKEN ?= $(shell cat ~/.ssh/dockerhub.token)

OSTYPES := debian fedora al2023

public-all: $(addprefix public-,$(OSTYPES))
	echo "$(DOCKERHUB_TOKEN)" | docker login -u rlauer --password-stdin
	docker tag bedrock-debian:latest $(REPO):latest
	docker push $(REPO):latest

.PHONY: $(addprefix public-,$(OSTYPES)) public-all

public-fedora: bedrock-fedora
include dockerhub.mk

public-al2023: bedrock-al2023
include dockerhub.mk

public-debian: bedrock-debian
include dockerhub.mk

dist_noinst_DATA = \
    $(XML_FILES) \
    $(APACHE_CONF) \
    $(TAGX) \
    $(BEDROCK_CONF) \
    $(DOCKER_COMPOSE) \
    requires \
    test-requires \
    bedrock.env.in \
    apache2.conf.in

CLEANFILES += $(CONFIG_FILES) bedrock.md5sum $(TARBALL)
