# -*- mode: makefile; -*-

SUBDIRS = bin src cpan docker .

# The ACLOCAL_AMFLAGS are used by 'autoreconf' and by the Makefile
# rebuild rule when they need to run 'aclocal'.
ACLOCAL_AMFLAGS = -I autotools

########################################################################
# RPM installation only (website build)
#
# just in case the session directory has not been created
apache_session_DATA = 
#
bedrockdir = $(apache_default_htdocsdir)/bedrock
bedrock_DATA =
########################################################################

FILES = \
    AUTHORS \
    bedrock-build \
    BUGS \
    INSTALL \
    NEWS \
    README.md \
    README-Apache.md \
    COPYING \
    ChangeLog \
    TODO.md

docdir = $(datadir)/bedrock/doc

dist_doc_DATA = $(FILES)

## ensure that these files make it into the distribution tarball
EXTRA_DIST = \
    bedrock.spec

MAINTAINERCLEANFILES = config.status \
                       config.log    \
                       bedrock.spec  \
                       $(PACKAGE)-$(VERSION).tar.gz \
                       *~

DISTCHECK_CONFIGURE_FLAGS = --enable-distcheck-hack

clean-local:
	for a in $$(ls bedrock*.tar.gz 2>/dev/null); do \
	  rm -f $$a; \
	done
