# ident "@(#) $Header$"
# ident "@(#)        $Name$"
#
# Name of Release: $Name$
# $Log$
# Revision 1.1  2000/10/16 14:00:18  sridhar
# Added Term.pm
#
#

include ../../make.pre

     CURRENT_PATH = SIS/InputSource

          TARGETS = Term.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Term.pm

install:
	$(INSTALL) Term.pm $(CURRENT_TARGET)

include ../../make.post
