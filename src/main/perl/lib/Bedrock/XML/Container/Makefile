# ident "@(#) $Header$"
# ident "@(#)        $Name$"
#
# Name of Release: $Name$
# $Log$
# Revision 1.1  2000/11/01 18:37:49  sridhar
# Adding XML capability to Bedrock. Basically we have a class here which
# can read and write arbitrary perl data structures in XML format.
#
#

include ../../make.pre

     CURRENT_PATH = XML/Container

          TARGETS = Scalar.pm Object.pm Array.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Scalar.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Object.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Array.pm

install:
	$(INSTALL) Scalar.pm	$(CURRENT_TARGET)
	$(INSTALL) Object.pm	$(CURRENT_TARGET)
	$(INSTALL) Array.pm	$(CURRENT_TARGET)

include ../../make.post
