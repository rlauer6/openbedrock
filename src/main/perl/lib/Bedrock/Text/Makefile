# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.3  2000/11/16 20:03:05  sridhar
# Does not descend directories for making. Just makes the main file
# which includes everything.
#
# Revision 1.2  2000/02/08 15:24:55  sridhar
# Added TagX
#
# Revision 1.1  2000/02/04 20:46:05  sridhar
# Makefile for build/install perl modules
#
# 

include ../make.pre

     CURRENT_PATH = Text

          TARGETS = URLEncode.pm TagX.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) URLEncode.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) TagX.pm

install:
	$(INSTALL) URLEncode.pm		$(CURRENT_TARGET)
	$(INSTALL) TagX.pm		$(CURRENT_TARGET)
	cd TagX		&& $(MAKE) $@

include ../make.post
