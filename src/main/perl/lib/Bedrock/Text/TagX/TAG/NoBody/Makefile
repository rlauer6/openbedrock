# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.2  2000/03/09 14:16:54  sridhar
# Added Raise.pm
#
# Revision 1.1  2000/02/08 15:24:59  sridhar
# Added TagX
#
# 

include ../../../../make.pre

     CURRENT_PATH = Text/TagX/TAG/NoBody

          TARGETS = Include.pm SQL.pm SQLConnect.pm Trace.pm Var.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Include.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) SQL.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) SQLConnect.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Trace.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Var.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Raise.pm

install:
	$(INSTALL) Include.pm		$(CURRENT_TARGET)
	$(INSTALL) SQL.pm		$(CURRENT_TARGET)
	$(INSTALL) SQLConnect.pm	$(CURRENT_TARGET)
	$(INSTALL) Trace.pm		$(CURRENT_TARGET)
	$(INSTALL) Var.pm		$(CURRENT_TARGET)
	$(INSTALL) Raise.pm		$(CURRENT_TARGET)

include ../../../../make.post
