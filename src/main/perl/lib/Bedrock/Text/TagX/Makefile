# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.8  2000/08/25 20:44:21  sridhar
# Added Scalar.pm
#
# Revision 1.7  2000/07/05 18:01:18  sridhar
# Removed Header.pm
#
# Revision 1.6  2000/06/28 18:55:57  sridhar
# Added Header.pm
#
# Revision 1.5  2000/06/01 18:38:45  sridhar
# Added Func.pm and Parser.pm
#
# Revision 1.4  2000/04/24 12:45:47  sridhar
# Added TagX::Log for logging messages
#
# Revision 1.3  2000/04/13 15:05:41  sridhar
# Adding Term.pm and Expr.pm
#
# Revision 1.2  2000/03/09 14:11:25  sridhar
# Added new class Output.pm.
#
# Revision 1.1  2000/02/08 15:24:56  sridhar
# Added TagX
#
# 

include ../../make.pre

     CURRENT_PATH = Text/TagX

          TARGETS = TAG.pm Doc.pm Output.pm Expr.pm Term.pm Log.pm Parser.pm Func.pm \
		    Scalar.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) TAG.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Output.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Expr.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Term.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Parser.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Func.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Log.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Scalar.pm
	cd TAG		&& $(MAKE) $@
	cd Term		&& $(MAKE) $@

install:
	$(INSTALL) TAG.pm		$(CURRENT_TARGET)
	$(INSTALL) Output.pm		$(CURRENT_TARGET)
	$(INSTALL) Doc.pm		$(CURRENT_TARGET)
	$(INSTALL) Expr.pm		$(CURRENT_TARGET)
	$(INSTALL) Term.pm		$(CURRENT_TARGET)
	$(INSTALL) Parser.pm		$(CURRENT_TARGET)
	$(INSTALL) Func.pm		$(CURRENT_TARGET)
	$(INSTALL) Log.pm		$(CURRENT_TARGET)
	$(INSTALL) Scalar.pm		$(CURRENT_TARGET)
	cd TAG		&& $(MAKE) $@
	cd Term		&& $(MAKE) $@

include ../../make.post
