# ident "@(#) $Header$"
# ident "@(#)        $Name$"
#
# Name of Release: $Name$
# $Log$
# Revision 1.2  2001/02/14 14:19:06  sridhar
# Improved makefile with macros
#
# Revision 1.1  2000/11/07 14:08:25  sridhar
# Adding SDBM.pm and GDBM.pm
#
#

include ../../../make.pre

     CURRENT_PATH = BLM/Startup/Session

          TARGETS = SDBM.pm GDBM.pm

all: $(TARGETS)

install:: $(TARGETS:%=%-install)

include ../../../make.post
