# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.2  2000/05/17 19:51:55  sridhar
# Added a file Module.pm which basically is the super class of all
# Bedrock modules
#
# Revision 1.1  2000/05/17 14:30:18  sridhar
# Bedrock loadable modules support.
#
#

include ../make.pre

     CURRENT_PATH = Bedrock

          TARGETS = Modules.pm Module.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Modules.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Module.pm
	cd Modules		&& $(MAKE) $@

install:
	$(INSTALL) Modules.pm	$(CURRENT_TARGET)
	$(INSTALL) Module.pm	$(CURRENT_TARGET)
	cd Modules		&& $(MAKE) $@

include ../make.post
