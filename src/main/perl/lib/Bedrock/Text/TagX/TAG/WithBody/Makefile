# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/02/08 15:25:02  sridhar
# Added TagX
#
# 

include ../../../../make.pre

     CURRENT_PATH = Text/TagX/TAG/WithBody

          TARGETS = Foreach.pm If.pm SQLSelect.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Foreach.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) If.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) SQLSelect.pm
	cd If		&& $(MAKE) $@

install:
	$(INSTALL) Foreach.pm		$(CURRENT_TARGET)
	$(INSTALL) If.pm		$(CURRENT_TARGET)
	$(INSTALL) SQLSelect.pm		$(CURRENT_TARGET)
	cd If		&& $(MAKE) $@

include ../../../../make.post
