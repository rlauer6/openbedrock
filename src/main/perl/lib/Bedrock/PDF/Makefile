# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/09/15 14:25:43  sridhar
# Added Bedrock/PDF/Makefile
#
#

include ../../make.pre

     CURRENT_PATH = Bedrock/PDF

          TARGETS = Maker.pm Handle.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Maker.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Handle.pm

install:
	$(INSTALL) Maker.pm	$(CURRENT_TARGET)
	$(INSTALL) Handle.pm	$(CURRENT_TARGET)

include ../../make.post
