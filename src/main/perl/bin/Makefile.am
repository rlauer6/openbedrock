## Process this file with automake to produce Makefile.in   -*-Makefile-*-

#SUBDIRS =  \
#          .

INPUT_TEMPLATES = bedrock-create-site.in

# "static" scripts
SSCRIPTS =
# "generated" scripts (filtered here by do_subst)
GSCRIPTS = bedrock-create-site-$(VERSION)

# "static" man pages
SMANPAGES =
# "generated" man pages
GMANPAGES = bedrock-create-site.1


bin_SCRIPTS = $(SSCRIPTS) $(GSCRIPTS)

dist_noinst_DATA = $(INPUT_TEMPLATES)

man1_MANS = bedrock-create-site.1

CLEANFILES = $(GSCRIPTS) $(GMANPAGES)

@do_subst_command@

bedrock-create-site-$(VERSION): $(top_builddir)/src/main/resources/bedrock-perl5-inc-begin-block.snippet
bedrock-create-site-$(VERSION): bedrock-create-site.in

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
bedrock-create-site-$(VERSION): Makefile
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


bedrock-create-site.1: bedrock-create-site.in
	"$(POD2MAN)" $< \
	    --center='Bedrock' \
	    --release=$(PACKAGE)-$(VERSION) \
	    --section=1 > $@


install-exec-hook:
	cd $(DESTDIR)$(bindir) && \
	    for s in $(bin_SCRIPTS); do \
	        _t_base="$$(echo "$$s" | sed -e 's/[-]$(VERSION)$$//')" ;\
	        $(LN_S) "$$s" "$${_t_base}" ;\
	        test $$? -eq 0 || exit 1    ;\
	    done
