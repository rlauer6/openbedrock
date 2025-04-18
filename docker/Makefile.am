SUBDIRS = .

DOCKERFILE = \
    Dockerfile.in

GDOCKERFILE= $(DOCKERFILE:.in=)

@do_subst_command@

all: config

REPOS = \
   bedrock.repo \
   perl-aws.repo

XML_FILES = \
   mysql-session.xml.in \
   data-sources.xml.in \
   redis-session.xml.in \
   redis.xml.in

YML_FILES = \
   docker-compose.yml.in

TAGX = \
  tagx.xml.in

GTAGX = $(TAGX:.xml.in=.xml)

$(GTAGX): % : %.in
	if test -n "$(STREAM_LOGS)"; then \
	  html_logfile="STDERR"; \
	fi; \
	if test -n "$(STREAM_LOGS)"; then \
	  logfile="STDERR"; \
	else \
	  logfile="bedrock.log"; \
	fi; \
	$(do_subst) $< | sed -e 's,@logfile@,'$$logfile',' \
	    -e 's,@html_logfile@,'$$html_logfile',' >$@

APACHE_CONF = \
  httpd.conf.in

GAPACHE_CONF = $(APACHE_CONF:.conf.in=.conf)

BEDROCK_CONF = \
  perl_bedrock.conf.in \
  bedrock.conf.in \
  bedrock-info.conf.in \
  bedrock-session-files.conf.in \
  bedrock-autocomplete.conf.in

GBEDROCK_CONF = $(BEDROCK_CONF:.conf.in=.conf)

%: %.in
	$(do_subst) $< > $@

%.conf: %.conf.in
	if test -n "$(STREAM_LOGS)"; then \
	  error_log="/dev/fd/1"; \
	else \
	  error_log="/var/www/log/error_log"; \
	fi; \
	if test -n "$(STREAM_LOGS)"; then \
	  access_log="/dev/fd/1"; \
	else \
	  access_log="/var/www/log/access_log"; \
	fi; \
	tmp=$$(mktemp); \
	sed -e 's,@error_log@,'$$error_log',' \
	    -e 's,@access_log@,'$$access_log',' \
	    -e 's,\@PACKAGE_VERSION\@,'@PACKAGE_VERSION@',' < $< >$$tmp; \
	$(do_subst) $$tmp > $@; \
	rm $$tmp;


GXML_FILES = $(XML_FILES:.xml.in=.xml)

GYML_FILES = $(YML_FILES:.yml.in=.yml)

$(GXML_FILES): % : %.in
	SESSION="$(SESSION)"; \
	SESSION=$${SESSION:-mysql}; \
	DBI_USER="$(DBI_USER)";\
	DBI_USER=$${DBI_USER:-fred}; \
	DBI_PASS="$(DBI_PASS)";\
	DBI_PASS=$${DBI_PASS:-flintstone}; \
	DBI_ROOT_PASS="$(DBI_ROOT_PASS)";\
	DBI_ROOT_PASS=$${DBI_ROOT_PASS:-bedrock}; \
	DBI_HOST="$(DBI_HOST)"; \
	DBI_HOST=$${DBI_HOST:-docker_db_1}; \
	DBI_DB="$(DBI_DB)";\
	DBI_DB=$${DBI_DB:-bedrock}; \
	tmp=$$(mktemp); \
	sed -e 's/@session@/'$$SESSION'/g' \
            -e 's/@dbi_user@/'$$DBI_USER'/g' \
	    -e 's/@dbi_pass@/'$$DBI_PASS'/g' \
	    -e 's/@dbi_db@/'$$DBI_DB'/g' \
	    -e 's/@dbi_root_pass@/'$$DBI_ROOT_PASS'/g' \
	    -e 's/@dbi_host@/'$$DBI_HOST'/g' < $< >$$tmp; \
	$(do_subst) $$tmp > $@; \
	rm $$tmp;

$(GYML_FILES): % : %.in
	SESSION="$(SESSION)"; \
	SESSION=$${SESSION:-mysql}; \
	DBI_USER="$(DBI_USER)"; \
	DBI_USER=$${DBI_USER:-fred}; \
	DBI_PASS="$(DBI_PASS)"; \
	DBI_PASS=$${DBI_PASS:-flintstone}; \
	DBI_ROOT_PASS="$(DBI_ROOT_PASS)"; \
	DBI_ROOT_PASS=$${DBI_ROOT_PASS:-bedrock}; \
	DBI_HOST="$(DBI_HOST)"; \
	DBI_HOST=$${DBI_HOST:-docker_db_1}; \
	DBI_DB="$(DBI_DB)"; \
	DBI_DB=$${DBI_DB:-bedrock}; \
	tmp=$$(mktemp); \
	sed -e 's/@session@/'$$SESSION'/g' \
	    -e 's/@dbi_user@/'$$DBI_USER'/g' \
	    -e 's/@dbi_pass@/'$$DBI_PASS'/g' \
	    -e 's/@dbi_db@/'$$DBI_DB'/g' \
	    -e 's/@dbi_root_pass@/'$$DBI_ROOT_PASS'/g' \
	    -e 's/@dbi_host@/'$$DBI_HOST'/g' < $< >$$tmp; \
	$(do_subst) $$tmp > $@; \
	rm $$tmp;

CONFIG_FILES = \
    $(GXML_FILES) \
    $(GYML_FILES) \
    $(GAPACHE_CONF) \
    $(GBEDROCK_CONF) \
    $(GTAGX)

FILES = \
    $(REPOS) \
    $(XML_FILES) \
    $(YML_FILES)

CLEANFILES = \
    $(GXML_FILES) \
    $(GYML_FILES) \
    $(GAPACHE_CONF) \
    $(GBEDROCK_CONF) \
    $(GTAGX) \
    docker-image

dist_noinst_DATA = \
    $(FILES) \
    $(DOCKERFILE) \
    $(APACHE_CONF) \
    $(TAGX) \
    $(BEDROCK_CONF)

.PHONY: config
config: $(CONFIG_FILES)
	echo $(GYML_FILES)


########################################################################
# MySQL server certificates for Docker
########################################################################

CA_KEY  = mysql-certs/mysqld-ca-key.pem
KEY     = mysql-certs/mysqld-server-key.pem
CERT    = mysql-certs/mysqld-server-cert.pem
CA_CERT = mysql-certs/mysqld-ca-cert.pem
CSR     = mysql-certs/mysqld-server-req.pem

########################################################################
# !! NOTE !!
########################################################################
#
# Starting with MySQL 8.4 self-signed certificates will be create by
# MySQL if no certificates are installed.  We have a target here
# 'certs' but we're not using them in 'docker-compose.yml' anymore
# because 8.4 will not use our self signed certs.
#
########################################################################

.PHONY: certs
certs:
	if ! [ "$$(id -u)" = "0" ]; then \
	  echo "ERROR: must be root"; \
	  false; \
	fi
	test -d mysql-certs || mkdir mysql-certs
	chown 999:999 mysql-certs
	openssl genrsa 2048 > $(CA_KEY)
	openssl req -sha1 -new -x509 -nodes -days 3650 -key $(CA_KEY) -subj "/C=FR/ST=/L=/O=mysqld/CN=mysqld-CA" > $(CA_CERT)
	openssl req -sha1 -newkey rsa:2048 -days 3650 -nodes -keyout $(KEY) -subj "/C=FR/ST=/L=/O=mysqld/CN=mysqld-server" > $(CSR)
	openssl rsa -in $(KEY) -out $(KEY)
	openssl x509 -sha1 -req -in $(CSR) -days 3650 -CA $(CA_CERT) -CAkey $(CA_KEY) -set_serial 01 > $(CERT)
	chown 999:999 mysql-certs/*
	chmod 0644 mysql-certs/*.pem
	chmod 0600 mysql-certs/*key*.pem

# -------------------------------------
# MySQL client certificate for Docker
# -------------------------------------
CLIENT_KEY  = mysql-certs-client/mysql-client-key.pem
CLIENT_CSR  = mysql-certs-client/mysql-client-req.pem
CLIENT_CERT = mysql-certs-client/mysql-client-cert.pem

.PHONY: client-cert
client-cert: certs
	test -d mysql-client-cert || mkdir mysql-client-cert
	openssl req -sha1 -newkey rsa:2048 -days 3650 -nodes -keyout $(CLIENT_KEY) > $(CLIENT_CSR) -subj "/C=FR/ST=/L=/O=mysql-client/CN=mysql-client"
	openssl rsa -in $(CLIENT_KEY) -out $(CLIENT_KEY)
	openssl x509 -sha1 -req -in $(CLIENT_CSR) -days 3650 -CA $(CA_CERT) \
                -CAkey $(CA_KEY) -set_serial 01 > $(CLIENT_CERT)

DOCKERFILE_DEBIAN      = Dockerfile.debian
DOCKERFILE_DEBIAN_BASE = Dockerfile.bedrock-debian-base

DOCKERFILE_AL2023      = Dockerfile.al2023
DOCKERFILE_AL2023_BASE = Dockerfile.bedrock-al2023-base

DOCKERFILE_FEDORA      = Dockerfile.fedora
DOCKERFILE_FEDORA_BASE = Dockerfile.bedrock-fedora-base

DOCKERFILE_GITHUB = Dockerfile.github

BEDROCK_VERSION = $(shell cat $(top_srcdir)/VERSION)

$(top_srcdir)/bedrock-$(BEDROCK_VERSION).tar.gz:
	cd $(top_srcdir); \
	$(MAKE) distcheck

$(top_srcdir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz: $(top_srcdir)/bedrock-$(BEDROCK_VERSION).tar.gz
	cd $(top_srcdir)/cpan; \
	make cpan

Bedrock-$(BEDROCK_VERSION).tar.gz: $(top_srcdir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz
	cp $(top_srcdir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz Bedrock-$(BEDROCK_VERSION).tar.gz

bedrock-debian-base: $(DOCKERFILE_DEBIAN_BASE)
	docker build -f $< . -t $@ && touch $@

bedrock-fedora-base: $(DOCKERFILE_FEDORA_BASE)
	docker build -f $< . -t $@ && touch $@

bedrock-al2023-base: $(DOCKERFILE_AL2023_BASE)
	docker build -f $< . -t $@ && touch $@

bedrock-debian: $(DOCKERFILE_DEBIAN) Bedrock-$(BEDROCK_VERSION).tar.gz bedrock-debian-base
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build --build-arg VERSION=$(BEDROCK_VERSION) -f $< . -t $@:latest | tee $$LOG; \
	cat $$LOG | grep 'Successfully built' | awk '{print $$3}' > $@; \
	rm $$LOG;

bedrock-fedora: $(DOCKERFILE_FEDORA) Bedrock-$(BEDROCK_VERSION).tar.gz bedrock-fedora-base
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build  --build-arg VERSION=$(BEDROCK_VERSION) -f $< . -t $@:latest | tee $$LOG; \
	cat $$LOG | grep 'Successfully built' | awk '{print $$3}' > $@; \
	rm $$LOG;

bedrock-al2023: $(DOCKERFILE_AL2023) Bedrock-$(BEDROCK_VERSION).tar.gz bedrock-al2023-base
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build  --build-arg VERSION=$(BEDROCK_VERSION) -f $< . -t $@:latest | tee $$LOG; \
	cat $$LOG | grep 'Successfully built' | awk '{print $$3}' > $@; \
	rm $$LOG;

bedrock-test: $(DOCKERFILE_GITHUB)
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build -f $< . -t $@:latest | tee $$LOG; \
	cat $$LOG | grep 'Successfully built' | awk '{print $$3}' > $@; \
	rm $$LOG;
	cat ~/.ssh/github.token | docker login ghcr.io -u rlauer6 --password-stdin
	docker build -f $< . -t ghcr.io/rlauer6/bedrock-test
	docker push ghcr.io/rlauer6/bedrock-test:latest

clean-local:
	set -x; \
	bedrock="$$(docker ps -a | tail -n +2 | grep 'bedrock' | awk '{print $$1}')"; \
	echo $$bedrock; \
	if test -n "$$bedrock"; then \
	  docker rm -f $$bedrock; \
	fi;

.PHONY: realclean

realclean: clean
	if test -n "$$(docker image list | awk '{print $$1}' | grep '^bedrock$$')"; then \
	  docker rmi bedrock; \
	fi
