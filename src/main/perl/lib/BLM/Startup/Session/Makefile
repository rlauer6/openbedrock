# ident "@(#) $Header$"
# ident "@(#)        $Name$"
#
# Name of Release: $Name$
# $Log$
# Revision 1.1  2000/11/07 14:08:25  sridhar
# Adding SDBM.pm and GDBM.pm
#
#

include ../../../make.pre

     CURRENT_PATH = BLM/Startup/Session

          TARGETS = SDBM.pm GDBM.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) SDBM.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) GDBM.pm

install:
	$(INSTALL) SDBM.pm	$(CURRENT_TARGET)
	$(INSTALL) GDBM.pm	$(CURRENT_TARGET)

include ../../../make.post
