# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.2  2000/03/09 14:11:25  sridhar
# Added new class Output.pm.
#
# Revision 1.1  2000/02/08 15:24:56  sridhar
# Added TagX
#
# 

include ../../make.pre

     CURRENT_PATH = Text/TagX

          TARGETS = TAG.pm Doc.pm Output.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) TAG.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Output.pm
	cd TAG		&& $(MAKE) $@

install:
	$(INSTALL) TAG.pm		$(CURRENT_TARGET)
	$(INSTALL) Output.pm		$(CURRENT_TARGET)
	$(INSTALL) Doc.pm		$(CURRENT_TARGET)
	cd TAG		&& $(MAKE) $@

include ../../make.post
