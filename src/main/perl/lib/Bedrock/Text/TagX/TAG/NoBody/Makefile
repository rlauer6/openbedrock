# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.4  2000/08/17 17:23:05  sridhar
# Added Exec.pm
#
# Revision 1.3  2000/06/06 20:00:37  sridhar
# Added NULL.pm
#
# Revision 1.2  2000/03/09 14:16:54  sridhar
# Added Raise.pm
#
# Revision 1.1  2000/02/08 15:24:59  sridhar
# Added TagX
#
# 

include ../../../../make.pre

     CURRENT_PATH = Text/TagX/TAG/NoBody

          TARGETS = Include.pm SQL.pm SQLConnect.pm Trace.pm Var.pm NULL.pm Exec.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Include.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) SQL.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) SQLConnect.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Trace.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Var.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Raise.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) NULL.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Exec.pm

install:
	$(INSTALL) Include.pm		$(CURRENT_TARGET)
	$(INSTALL) SQL.pm		$(CURRENT_TARGET)
	$(INSTALL) SQLConnect.pm	$(CURRENT_TARGET)
	$(INSTALL) Trace.pm		$(CURRENT_TARGET)
	$(INSTALL) Var.pm		$(CURRENT_TARGET)
	$(INSTALL) Raise.pm		$(CURRENT_TARGET)
	$(INSTALL) NULL.pm		$(CURRENT_TARGET)
	$(INSTALL) Exec.pm		$(CURRENT_TARGET)

include ../../../../make.post
