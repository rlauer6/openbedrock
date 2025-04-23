#-*- mode: makefile; -*-

########################################################################
# The Dockerfiles for creating base images
# (e.g. Dockerfile.bedrock-al2023-base) install all of the
# dependencies for running a Bedrock enabled Apache server.
# 
# The Dockerfile.{ostype} (e.g. Dockerfile.debian) finalize the image so
# that is "Bedrock enabled".
#
# 1. install Bedrock
# 2. install Bedrock site (configuration files, documentation, etc)
# 3. prepare Apache environment (enable modules, etc)
# 4. runs start-server
#    a. run setup.sql
#    b. start Apache
########################################################################

include apache.mk

########################################################################
# Docker images
########################################################################

.PHONY: images
images: bedrock-debian bedrock-fedora bedrock-al2023

setup-sql: setup.sql.in
	$(do_subst) $< > $@

CLEANFILES += setup-sql

COMMON_DEPS = \
    $(CONFIG_FILES) \
    start-server \
    setup.sql \
    Bedrock-$(BEDROCK_VERSION).tar.gz

########################################################################
# debian
########################################################################
DOCKERFILE_DEBIAN      = Dockerfile.debian
DOCKERFILE_DEBIAN_BASE = Dockerfile.bedrock-debian-base

BEDROCK_DEBIAN_DEPS = \
    $(DOCKERFILE_DEBIAN) \
    debian.env \
    bedrock-debian-base \
    $(COMMON_DEPS)

.PHONY: debian
debian: bedrock-debian

bedrock-debian-base: $(DOCKERFILE_DEBIAN_BASE)
	docker build -f $< . -t $@ && touch $@

bedrock-debian: $(BEDROCK_DEBIAN_DEPS)
include bedrock-image.mk

debian.env: bedrock.env.in
	os_type="debian"; \
	$(do_subst) $< | \
	sed -e "s/[@]os_type[@]/$$os_type/g" > $@

CLEANFILES += debian.env

########################################################################
# Fedora
########################################################################
DOCKERFILE_FEDORA      = Dockerfile.fedora
DOCKERFILE_FEDORA_BASE = Dockerfile.bedrock-fedora-base

BEDROCK_FEDORA_DEPS = \
    $(DOCKERFILE_FEDORA) \
    fedora.env \
    $(CONFIG_FILES) \
    bedrock-fedora-base \
    Bedrock-$(BEDROCK_VERSION).tar.gz

.PHONY: fedora
fedora: bedrock-fedora

bedrock-fedora-base: $(DOCKERFILE_FEDORA_BASE)
	docker build -f $< . -t $@ && touch $@

bedrock-fedora: $(BEDROCK_FEDORA_DEPS)
include bedrock-image.mk

fedora.env: bedrock.env.in
	os_type="fedora"; \
	$(do_subst) $< | \
	sed -e "s/[@]os_type[@]/$$os_type/g" > $@

CLEANFILES += fedora.env

########################################################################
# Amazon Linux 2023
########################################################################
DOCKERFILE_AL2023      = Dockerfile.al2023
DOCKERFILE_AL2023_BASE = Dockerfile.bedrock-al2023-base

BEDROCK_AL2023_DEPS = \
    $(DOCKERFILE_AL2023) \
    al2023.env \
    $(CONFIG_FILES) \
    bedrock-al2023-base \
    Bedrock-$(BEDROCK_VERSION).tar.gz

.PHONY: al2023
al2023: bedrock-al2023

bedrock-al2023-base: $(DOCKERFILE_AL2023_BASE)
	docker build -f $< . -t $@ && touch $@

bedrock-al2023: $(BEDROCK_AL2023_DEPS)
include bedrock-image.mk

al2023.env: bedrock.env.in
	os_type="al2023"; \
	$(do_subst) $< | \
	sed -e "s/[@]os_type[@]/$$os_type/g" > $@

CLEANFILES += al2023.env

