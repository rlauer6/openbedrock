SUBDIRS = .
#-*- mode: makefile; -*-

@do_subst_command@

TARBALL = $(builddir)/Bedrock-$(PACKAGE_VERSION).tar.gz

TARBALL_CORE = $(builddir)/Bedrock-Core-$(PACKAGE_VERSION).tar.gz 

all: 

BEDROCK_SOURCE_FILES := $(shell git ls-files $(top_srcdir) | grep -vE '^(docker/|cpan/)')

$(top_builddir)/cpan/$(TARBALL): $(BEDROCK_SOURCE_FILES)
	cd $(top_builddir) && $(MAKE)
	cd $(top_builddir)/cpan && $(MAKE) clean && $(MAKE) cpan

$(top_builddir)/cpan/bedrock-core/$(TARBALL_CORE): $(BEDROCK_SOURCE_FILES)
	cd $(top_builddir) && $(MAKE)
	cd $(top_builddir)/cpan/bedrock-core && $(MAKE) clean && $(MAKE) cpan

$(TARBALL): $(top_builddir)/cpan/$(TARBALL)
	cp $<  $@

$(TARBALL_CORE): $(top_builddir)/cpan/bedrock-core/$(TARBALL_CORE)
	cp $< $@

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

########################################################################
# CLEAN_FILES will be incrementally added to in *.mk sections
########################################################################
CONFIG_FILES = 
CLEANFILES  =

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
# ...works for me (rlauer) but maybe not you!
########################################################################
DOCKERHUB_TOKEN ?= $(shell cat ~/.ssh/dockerhub.token)
DOCKERHUB_USER  ?= $(shell id -nu)
REPO            ?= $(DOCKERHUB_USER)/openbedrock

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
    $(BEDROCK_CONF) \
    $(DOCKER_COMPOSE) \
    cpanfile \
    cpanfile.snapshot \
    bedrock.env.in

CLEANFILES += $(TARBALL) $(TARBALL_CORE)
