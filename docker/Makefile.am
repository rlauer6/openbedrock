SUBDIRS = .

DOCKERFILE = \
    Dockerfile.in

@do_subst_command@

GDOCKERFILE = $(DOCKERFILE:.in=)

$(GDOCKERFILE): $(DOCKERFILE)
	$(do_subst) $< > $@

REPOS = \
   bedrock.repo \
   perl-aws.repo

XML_FILES = \
   mysql-session.xml.in \
   data-sources.xml.in

GXML_FILES = $(XML_FILES:.xml.in=.xml)

$(GXML_FILES): % : %.in
	DBI_USER="$(DBI_USER)";\
	DBI_USER=$${DBI_USER:-fred}; \
	DBI_PASS="$(DBI_PASS)";\
	DBI_PASS=$${DBI_PASS:-flintstone}; \
	DBI_HOST="$(DBI_HOST)";\
	DBI_HOST=$${DBI_HOST:-127.0.0.1}; \
	DBI_DB="$(DBI_DB)";\
	DBI_DB=$${DBI_DB:-bedrock}; \
	sed -e 's/@dbi_user@/'$$DBI_USER'/' \
	    -e 's/@dbi_pass@/'$$DBI_PASS'/' \
	    -e 's/@dbi_db@/'$$DBI_DB'/' \
	    -e 's/@dbi_host@/'$$DBI_HOST'/' < $< >$@

FILES = \
    $(REPOS) \
    $(XML_FILES)

CLEANFILES = \
    $(GDOCKERFILE) \
    $(GXML_FILES) \
    docker-image

dist_noinst_DATA = \
    $(FILES) \
    $(DOCKERFILE)

all:

xml: $(GXML_FILES)

docker-image: $(GDOCKERFILE) $(REPOS) $(GXML_FILES)
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
	fi; \
	if test -n "$$(docker image list | head -n +2 | grep '^bedrock')"; then \
	  docker rmi bedrock; \
	fi


