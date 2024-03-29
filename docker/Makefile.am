SUBDIRS = .

DOCKERFILE = \
    Dockerfile

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
  bedrock.conf.in \
  bedrock-info.conf.in \
  bedrock-session-files.conf.in \
  bedrock-autocomplete.conf.in

GBEDROCK_CONF = $(BEDROCK_CONF:.conf.in=.conf)

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
	sed -e 's,@error_log@,'$$error_log',' \
	    -e 's,@access_log@,'$$access_log',' \
	    -e 's,\@PACKAGE_VERSION\@,'@PACKAGE_VERSION@',' < $< >$@

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
	sed -e 's/@session@/'$$SESSION'/g' \
            -e 's/@dbi_user@/'$$DBI_USER'/g' \
	    -e 's/@dbi_pass@/'$$DBI_PASS'/g' \
	    -e 's/@dbi_db@/'$$DBI_DB'/g' \
	    -e 's/@dbi_root_pass@/'$$DBI_ROOT_PASS'/g' \
	    -e 's/@dbi_host@/'$$DBI_HOST'/g' < $< >$@

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
	sed -e 's/@session@/'$$SESSION'/g' \
	    -e 's/@dbi_user@/'$$DBI_USER'/g' \
	    -e 's/@dbi_pass@/'$$DBI_PASS'/g' \
	    -e 's/@dbi_db@/'$$DBI_DB'/g' \
	    -e 's/@dbi_root_pass@/'$$DBI_ROOT_PASS'/g' \
	    -e 's/@dbi_host@/'$$DBI_HOST'/g' < $< >$@

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

docker-image: $(DOCKERFILE) $(REPOS) $(CONFIG_FILES)
	set -x; LOG=$$(mktemp); \
	echo $$LOG; \
	docker build --no-cache -f $< . -t bedrock:latest | tee $$LOG; \
	cat $$LOG | grep 'Successfully built' | awk '{print $$3}' > $@; \
	rm $$LOG;

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
