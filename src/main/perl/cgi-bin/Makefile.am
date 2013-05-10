## Process this file with automake to produce Makefile.in   -*-Makefile-*-

#SUBDIRS =  \
#          .

INPUT_TEMPLATES = bedrock.cgi.in

# "static" scripts
SSCRIPTS =
# "generated" scripts (filtered here by do_subst)
GSCRIPTS = bedrock.cgi

# "static" man pages
SMANPAGES =
# "generated" man pages
GMANPAGES = bedrock.cgi.1


cgibin_SCRIPTS = $(SSCRIPTS) $(GSCRIPTS)

dist_noinst_DATA = $(INPUT_TEMPLATES)

man1_MANS = bedrock.cgi.1

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

bedrock.cgi.1: bedrock.cgi.in
	"$(POD2MAN)" $< \
	    --center='Bedrock' \
	    --name=$$(echo $< | sed -e 's/\.in$$//' | tr '[:lower:]' '[:upper:]') \
	    --release=$(PACKAGE)-$(VERSION) \
	    --section=1 > $@

install-data-hook:
	[ $$(id -u) == "0" ] && ln -s $(DESTDIR)$(libdir)/bedrock/cgi-bin/bedrock.cgi $(DESTDIR)/$(libdir)/bedrock/cgi-bin/bedrock-session-files.cgi || true;
	[ $$(id -u) == "0" ] && ln -s $(DESTDIR)$(libdir)/bedrock/cgi-bin/bedrock.cgi $(DESTDIR)/$(libdir)/bedrock/cgi-bin//bedrock-docs.cgi || true;
