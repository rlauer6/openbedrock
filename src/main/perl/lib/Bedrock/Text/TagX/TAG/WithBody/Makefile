# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.6  2000/11/13 18:45:11  sridhar
# Added Cache.pm
#
# Revision 1.5  2000/10/19 20:57:54  sridhar
# Moved Hush.pm to Sink.pm
#
# Revision 1.4  2000/10/18 18:15:33  sridhar
# Added Hush.pm
#
# Revision 1.3  2000/03/09 14:20:06  sridhar
# Added Try.pm and Catch.pm.
#
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

          TARGETS = Loop.pm If.pm Try.pm Catch.pm Sink.pm Cache.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Loop.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) If.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Try.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Catch.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Sink.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Cache.pm
	cd If		&& $(MAKE) $@
	cd Loop		&& $(MAKE) $@

install:
	$(INSTALL) If.pm		$(CURRENT_TARGET)
	$(INSTALL) Try.pm		$(CURRENT_TARGET)
	$(INSTALL) Catch.pm		$(CURRENT_TARGET)
	$(INSTALL) Loop.pm		$(CURRENT_TARGET)
	$(INSTALL) Sink.pm		$(CURRENT_TARGET)
	$(INSTALL) Cache.pm		$(CURRENT_TARGET)
	cd If		&& $(MAKE) $@
	cd Loop		&& $(MAKE) $@

include ../../../../make.post
