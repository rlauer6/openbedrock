# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.1  2000/02/04 20:46:05  sridhar
# Makefile for build/install perl modules
#
# 

include ../make.pre

     CURRENT_PATH = Text

          TARGETS = URLEncode.pm

all:
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) URLEncode.pm

install:
	$(INSTALL) URLEncode.pm		$(CURRENT_TARGET)

include ../make.post
