# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.9  2000/12/15 15:50:15  sridhar
# Removed Modules.pm since startup modules are now loaded dynamically too.
#
# Revision 1.8  2000/12/11 15:11:59  sridhar
# Vastly cleaned up.
#
# Revision 1.7  2000/11/20 18:20:04  sridhar
# Added UserSession.pm
#
# Revision 1.6  2000/11/07 14:10:51  sridhar
# Added Session/, Session.pm and AutoDB.pm
#
# Revision 1.5  2000/10/12 15:23:29  sridhar
# Added Hitcounter.pm
#
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

          TARGETS = Bedrock.pm Config.pm Env.pm Input.pm Cookie.pm Header.pm \
		    Hitcounter.pm Session.pm AutoDB.pm UserSession.pm Forum.pm Output.pm

all: $(TARGETS)
	cd Session	&& $(MAKE) $@

install:: $(TARGETS:%=%-install)
	cd Session && $(MAKE) $@

include ../../make.post
