# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/04/13 15:13:46  sridhar
# Adding TagX::Term::String and TagX::Term::Var -- component parts of an
# expression.
#
# Revision 1.1  2000/02/08 15:24:57  sridhar
# Added TagX
#
# 

include ../../../make.pre

     CURRENT_PATH = Text/TagX/Term

          TARGETS = String.pm Var.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) String.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Var.pm

install:
	$(INSTALL) String.pm		$(CURRENT_TARGET)
	$(INSTALL) Var.pm		$(CURRENT_TARGET)

include ../../../make.post
