# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.2  2000/03/02 14:53:17  sridhar
# 1. Added new Module Loop
# 2. Moved Foreach and SQLSelect to Loop subdir
#
# Revision 1.1  2000/02/08 15:25:02  sridhar
# Added TagX
#
# 

include ../../../../make.pre

     CURRENT_PATH = Text/TagX/TAG/WithBody

          TARGETS = Loop.pm If.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Loop.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) If.pm
	cd If		&& $(MAKE) $@
	cd Loop		&& $(MAKE) $@

install:
	$(INSTALL) If.pm		$(CURRENT_TARGET)
	$(INSTALL) Loop.pm		$(CURRENT_TARGET)
	cd If		&& $(MAKE) $@
	cd Loop		&& $(MAKE) $@

include ../../../../make.post
