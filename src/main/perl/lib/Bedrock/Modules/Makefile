# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/05/17 14:29:42  sridhar
# Adding Loadable module TimeNow -- support for current date and time in
# Bedrock pages
#
# 

include ../../make.pre

     CURRENT_PATH = Bedrock/Modules

          TARGETS = TimeNow.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) TimeNow.pm

install:
	$(INSTALL) TimeNow.pm		$(CURRENT_TARGET)

include ../../make.post
