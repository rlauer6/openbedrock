# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.4  2000/07/19 19:39:07  sridhar
# Added Modules.pm
#
# Revision 1.3  2000/07/05 17:55:50  sridhar
# Added Header.pm
#
# Revision 1.2  2000/06/07 18:49:07  sridhar
# Added Cookie.pm
#
# Revision 1.1  2000/06/06 20:42:09  sridhar
# Bedrock loadable modules for startup
#
#

include ../../make.pre

     CURRENT_PATH = BLM/Startup

          TARGETS = Modules.pm Bedrock.pm Config.pm Env.pm Input.pm Cookie.pm Header.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Modules.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Bedrock.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Config.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Env.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Input.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Cookie.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Header.pm

install:
	$(INSTALL) Modules.pm	$(CURRENT_TARGET)
	$(INSTALL) Bedrock.pm	$(CURRENT_TARGET)
	$(INSTALL) Config.pm	$(CURRENT_TARGET)
	$(INSTALL) Env.pm	$(CURRENT_TARGET)
	$(INSTALL) Input.pm	$(CURRENT_TARGET)
	$(INSTALL) Cookie.pm	$(CURRENT_TARGET)
	$(INSTALL) Header.pm	$(CURRENT_TARGET)

include ../../make.post
