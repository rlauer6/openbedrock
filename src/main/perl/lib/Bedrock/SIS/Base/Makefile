# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.3  2000/10/16 13:59:06  sridhar
# Added Shell.pm
#
# Revision 1.2  2000/06/09 17:51:17  sridhar
# Added Apache.pm
#
# Revision 1.1  2000/02/04 20:44:58  sridhar
# Makefile for build/install perl modules
#
# 

include ../../make.pre

     CURRENT_PATH = SIS/Base

          TARGETS = Apache.pm Shell.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Apache.pm
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Shell.pm

install:
	$(INSTALL) Apache.pm $(CURRENT_TARGET)
	$(INSTALL) Shell.pm $(CURRENT_TARGET)

include ../../make.post
