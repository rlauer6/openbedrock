# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/06/06 20:42:09  sridhar
# Bedrock loadable modules for startup
#
#

include ../../make.pre

     CURRENT_PATH = BLM/Startup

          TARGETS = Bedrock.pm Config.pm Env.pm Input.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Bedrock.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Config.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Env.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Input.pm

install:
	$(INSTALL) Bedrock.pm	$(CURRENT_TARGET)
	$(INSTALL) Config.pm	$(CURRENT_TARGET)
	$(INSTALL) Env.pm	$(CURRENT_TARGET)
	$(INSTALL) Input.pm	$(CURRENT_TARGET)

include ../../make.post
