# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/02/08 15:24:56  sridhar
# Added TagX
#
# 

include ../../make.pre

     CURRENT_PATH = Text/TagX

          TARGETS = TAG.pm Doc.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) TAG.pm
	cd TAG		&& $(MAKE) $@

install:
	$(INSTALL) TAG.pm		$(CURRENT_TARGET)
	$(INSTALL) Doc.pm		$(CURRENT_TARGET)
	cd TAG		&& $(MAKE) $@

include ../../make.post
