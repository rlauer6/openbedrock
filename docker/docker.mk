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

########################################################################
# Docker images
########################################################################

.PHONY: images
images:debian fedora al2023 .bedrock_rc

setup-sql: setup.sql.in
	$(do_subst) $< > $@

CLEANFILES += setup-sql

CLEANFILES += $(ENV_FILES)

perl5libdir = @perl5libdir@

$(ENV_FILES): bedrock.env.in
	os_type=$$(basename $@ .env); \
	$(do_subst) $< | sed "s/[@]os_type[@]/$$os_type/" > $@

BEDROCK_VERSION = @PACKAGE_VERSION@

########################################################################
# TBD: use pattern rule public-%: bedrock:% when `make` can be upgraded to 4+
########################################################################

########################################################################
# debian
########################################################################
DOCKERFILE_DEBIAN_BASE = Dockerfile.debian-base

.PHONY: debian-base
debian-base: bedrock-debian-base.id

bedrock-debian-base.id: $(DOCKERFILE_DEBIAN_BASE) cpanfile cpanfile.snapshot
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build $$NO_CACHE -f $< . -t $$(basename $@ .id) 2>&1 | tee $$LOG; \
	perl -0ne '/writing image (sha256:[^ ]+)\s/sm && print "$$1\n"' < $$LOG > $@; \
	rm $$LOG

DOCKERFILE_DEBIAN = Dockerfile.debian

BEDROCK_DEBIAN_DEPS = \
    $(DOCKERFILE_DEBIAN) \
    debian-base \
    $(TARBALL) \
    $(TARBALL_CORE) \
    entrypoint.sh \
    setup.sql

.PHONY: debian
debian: bedrock-debian.id

bedrock-debian.id: $(BEDROCK_DEBIAN_DEPS)
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build $$NO_CACHE --build-arg VERSION=$(BEDROCK_VERSION) -f $< . -t $$(basename $@ .id):latest 2>&1 | tee $$LOG; \
	perl -0ne '/writing image (sha256:[^ ]+)\s/sm && print "$$1\n"' < $$LOG > $@; \
	rm $$LOG;

########################################################################
# Fedora
########################################################################

.PHONY: fedora-base
fedora-base: bedrock-fedora-base.id

bedrock-fedora-base.id: $(DOCKERFILE_FEDORA_BASE)
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build $$NO_CACHE -f $< . -t $$(basename $@ .id) 2>&1 | tee $$LOG; \
	perl -0ne '/writing image (sha256:[^ ]+)\s/sm && print "$$1\n"' < $$LOG > $@; \
	rm $$LOG

DOCKERFILE_FEDORA      = Dockerfile.fedora
DOCKERFILE_FEDORA_BASE = Dockerfile.fedora-base

BEDROCK_FEDORA_DEPS = \
    $(DOCKERFILE_FEDORA) \
    fedora-base \
    $(TARBALL) \
    $(TARBALL_CORE) \
    entrypoint.sh \
    setup.sql

.PHONY: fedora
fedora: bedrock-fedora.id

bedrock-fedora.id: $(BEDROCK_FEDORA_DEPS)
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build $$NO_CACHE --build-arg VERSION=$(BEDROCK_VERSION) -f $< . -t $$(basename $@ .id):latest 2>&1 | tee $$LOG; \
	perl -0ne '/writing image (sha256:[^ ]+)\s/sm && print "$$1\n"' < $$LOG > $@; \
	rm $$LOG;

########################################################################
# Amazon Linux 2023
########################################################################
DOCKERFILE_AL2023      = Dockerfile.al2023
DOCKERFILE_AL2023_BASE = Dockerfile.al2023-base

.PHONY: al2023-base
al2023-base: bedrock-al2023-base.id

bedrock-al2023-base.id: $(DOCKERFILE_AL2023_BASE)	
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build $$NO_CACHE -f $< . -t $$(basename $@ .id):latest 2>&1 | tee $$LOG; \
	perl -0ne '/writing image (sha256:[^ ]+)\s/sm && print "$$1\n"' < $$LOG > $@; \
	rm $$LOG;

BEDROCK_AL2023_DEPS = \
    $(DOCKERFILE_AL2023) \
    al2023-base \
    $(TARBALL) \
    $(TARBALL_CORE) \
    entrypoint.sh \
    setup.sql

.PHONY: al2023
al2023: bedrock-al2023.id

bedrock-al2023.id: $(BEDROCK_AL2023_DEPS)
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build $$NO_CACHE --build-arg VERSION=$(BEDROCK_VERSION)  -f $< . -t $$(basename $@ .id):latest 2>& 1| tee $$LOG; \
	perl -0ne '/writing image (sha256:[^ ]+)\s/sm && print "$$1\n"' < $$LOG > $@; \
	rm $$LOG;

CLEANFILES += \
    bedrock-al2023.id \
    bedrock-al2033-base.id \
    bedrock-debian.id \
    bedrock-debian-base.id \
    bedrock-fedora.id \
    bedrock-fedora-base.id
