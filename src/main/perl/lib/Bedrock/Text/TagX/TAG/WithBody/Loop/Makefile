# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.2  2000/07/20 20:07:40  sridhar
# Added While.pm
#
# Revision 1.1  2000/03/02 15:00:33  sridhar
# Added new directory Loop and moved Foreach.pm and SQLSelect.pm to it.
#
# Revision 1.1  2000/02/04 20:46:05  sridhar
# Makefile for build/install perl modules
#
# 

include ../../../../../make.pre

     CURRENT_PATH = Text/TagX/TAG/WithBody/Loop

          TARGETS = Foreach.pm SQLSelect.pm While.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Foreach.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) SQLSelect.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) While.pm

install:
	$(INSTALL) Foreach.pm		$(CURRENT_TARGET)
	$(INSTALL) SQLSelect.pm		$(CURRENT_TARGET)
	$(INSTALL) While.pm		$(CURRENT_TARGET)

include ../../../../../make.post
