## Process this file with automake to produce Makefile.in   -*-Makefile-*-

#SUBDIRS =  \
#          .

CGI_TEMPLATES = \
    bedrock.cgi.in \
    bedrock-docs.cgi.in

# "static" scripts
SSCRIPTS =
# "generated" scripts (filtered here by do_subst)
GSCRIPTS = $(CGI_TEMPLATES:.cgi.in=.cgi)

# "static" man pages
SMANPAGES =
# "generated" man pages
GMANPAGES = $(GSCRIPTS:.cgi=.cgi.1)

cgibin_SCRIPTS = $(SSCRIPTS) $(GSCRIPTS)

dist_noinst_DATA = $(CGI_TEMPLATES)

man1_MANS = $(GMANPAGES)

CLEANFILES = $(GSCRIPTS) $(GMANPAGES)

@do_subst_command@

bedrock.cgi: @bedrock_perl5_inc_begin_block_snippet_filepath@
bedrock.cgi: bedrock.cgi.in

# This file depends on Makefile so it will be rebuilt if $(VERSION) or other
# do_subst'ituted variables change. Use chmod a-w to prevent people from
# editing the wrong file by accident.
#
# Note that the script depends on the naming convention:
#
# Target:
#
#     <PROG_NAME_BASE>-$(VERSION)
#
# is generated from:
#
#     <PROG_NAME_BASE>.in
#
bedrock.cgi: Makefile
	set -e ;\
	rm -f "$@" "$@.tmp" ;\
	_t_base="$$(echo "$@" | sed -e 's/[-]$(VERSION)$$//')" ;\
	$(do_subst) "$(srcdir)/$${_t_base}.in" > "$@.tmp"      ;\
	mv "$@.tmp" "$@"    ;\
	"$(top_srcdir)/bin/splice-in-file" "$@" '___REPLACE_ME__BEGIN_BLOCK__CONFIGURED_PERL_INC___' \
	  '@bedrock_perl5_inc_begin_block_snippet_filepath@' 'filter' > '$@.tmp' ;\
	mv "$@.tmp" "$@"    ;\
	chmod a-w "$@"      ;\
	chmod a+rx "$@"

bedrock-docs.cgi: bedrock-docs.cgi.in
	set -e ;\
	rm -f "$@" "$@.tmp" ;\
	_t_base="$$(echo "$@" | sed -e 's/[-]$(VERSION)$$//')" ;\
	$(do_subst) "$(srcdir)/$${_t_base}.in" > "$@.tmp"      ;\
	mv "$@.tmp" "$@"    ;\
	chmod a-w "$@"      ;\
	chmod a+rx "$@"

$(GMANPAGES): $(CGI_TEMPLATES)
	"$(POD2MAN)" $< \
	    --center='Bedrock' \
	    --name=$$(echo $< | sed -e 's/\.in$$//' | tr '[:lower:]' '[:upper:]') \
	    --release=$(PACKAGE_VERSION) \
	    --section=1 > $@

install-data-hook:
	cp $(DESTDIR)$(datadir)/bedrock/cgi-bin/bedrock.cgi $(DESTDIR)/$(datadir)/bedrock/cgi-bin/bedrock-session-files.cgi || true;
	cp $(DESTDIR)$(datadir)/bedrock/cgi-bin/bedrock.cgi $(DESTDIR)/$(datadir)/bedrock/cgi-bin//bedrock-autocomplete.cgi || true;

uninstall-hook:
	rm -f $(DESTDIR)$(datadir)/bedrock/cgi-bin/bedrock-session-files.cgi || true;
	rm -f $(DESTDIR)$(datadir)/bedrock/cgi-bin/bedrock-autocomplete.cgi || true;

#	rm -f $(DESTDIR)$(datadir)/bedrock/cgi-bin/bedrock-docs.cgi || true;
#	cp $(DESTDIR)$(datadir)/bedrock/cgi-bin/bedrock.cgi $(DESTDIR)/$(datadir)/bedrock/cgi-bin//bedrock-docs.cgi || true;
