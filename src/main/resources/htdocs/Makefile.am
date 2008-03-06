## Process this file with automake to produce Makefile.in -*-Makefile-*-

SUBDIRS = img \
          .

dist_htdocs_DATA = error.rock

install-data-hook:
	cd $(DESTDIR)$(htdocsdir) && \
	    for s in $(dist_htdocs_DATA); do \
	        dotroc_fname="$$(echo "$$s" | sed -e 's/\.rock$$/.roc/')" ;\
	        rm -f "$${dotroc_fname}" && $(LN_S) "$$s" "$${dotroc_fname}" ;\
	        test $$? -eq 0 || exit 1    ;\
	    done
