# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/05/17 14:30:18  sridhar
# Bedrock loadable modules support.
#
#

include ../make.pre

     CURRENT_PATH = Bedrock

          TARGETS = Modules.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Modules.pm
	cd Modules		&& $(MAKE) $@

install:
	$(INSTALL) Modules.pm	$(CURRENT_TARGET)
	cd Modules		&& $(MAKE) $@

include ../make.post
