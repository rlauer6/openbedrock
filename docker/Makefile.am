SUBDIRS = .
#-*- mode: makefile; -*-

@do_subst_command@

all: bedrock

MYSQL_HOST          = @mysql_host@
MYSQL_PASSWORD      = @mysql_password@
MYSQL_ROOT_PASSWORD = @mysql_root_password@
MYSQL_USER          = @mysql_user@
MYSQL_DATABASE      = @mysql_database@

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
    test-requires

CLEANFILES += $(CONFIG_FILES)

clean-local:
	set -x; \
	bedrock="$$(docker ps -a | tail -n +2 | grep 'bedrock' | awk '{print $$1}')"; \
	echo $$bedrock; \
	if test -n "$$bedrock"; then \
	  docker rm -f $$bedrock; \
	fi;
