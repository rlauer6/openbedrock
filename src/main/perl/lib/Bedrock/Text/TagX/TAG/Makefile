# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/02/08 15:24:57  sridhar
# Added TagX
#
# 

include ../../../make.pre

     CURRENT_PATH = Text/TagX/TAG

          TARGETS = WithBody.pm NoBody.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) WithBody.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) NoBody.pm
	cd WithBody		&& $(MAKE) $@
	cd NoBody		&& $(MAKE) $@

install:
	$(INSTALL) WithBody.pm		$(CURRENT_TARGET)
	$(INSTALL) NoBody.pm		$(CURRENT_TARGET)
	cd WithBody		&& $(MAKE) $@
	cd NoBody		&& $(MAKE) $@

include ../../../make.post
