# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
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
	cd TagX		&& $(MAKE) $@

install:
	$(INSTALL) URLEncode.pm		$(CURRENT_TARGET)
	$(INSTALL) TagX.pm		$(CURRENT_TARGET)
	cd TagX		&& $(MAKE) $@

include ../make.post
