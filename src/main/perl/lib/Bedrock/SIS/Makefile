# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/09/18 14:20:27  sridhar
# Moved some generally useful modules under Perl/SIS to Perl/Bedrock/SIS.
#
# Revision 1.6  2000/08/17 17:21:06  sridhar
# Added SIS::BufferStream
#
# Revision 1.5  2000/08/11 14:11:11  sridhar
# Added StructArray.pm
#
# Revision 1.4  2000/08/04 15:33:15  sridhar
# Added Server.pm -- general purpose module for connecting to a server.
# Added Server directory containing special purpose search modules.
#
# Revision 1.3  2000/07/05 17:53:47  sridhar
# Added Dump.pm
#
# Revision 1.2  2000/06/06 19:53:14  sridhar
# Added Hash.pm and Array.pm
#
# Revision 1.1  2000/02/04 20:44:25  sridhar
# Makefile for building/installing SIS Perl modules
#
# 

include ../../make.pre

     CURRENT_PATH = SIS

          TARGETS = Base.pm Config.pm InputSource.pm Log.pm Hash.pm Array.pm Dump.pm \
		    BufferStream.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Base.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Config.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) InputSource.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Log.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Hash.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Array.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Dump.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) BufferStream.pm
	cd Base		&& $(MAKE) $@

install:
	$(INSTALL) Base.pm		$(CURRENT_TARGET)
	$(INSTALL) Config.pm		$(CURRENT_TARGET)
	$(INSTALL) InputSource.pm	$(CURRENT_TARGET)
	$(INSTALL) Log.pm		$(CURRENT_TARGET)
	$(INSTALL) Hash.pm		$(CURRENT_TARGET)
	$(INSTALL) Array.pm		$(CURRENT_TARGET)
	$(INSTALL) Dump.pm		$(CURRENT_TARGET)
	$(INSTALL) BufferStream.pm	$(CURRENT_TARGET)
	cd Base		&& $(MAKE) $@

include ../../make.post
