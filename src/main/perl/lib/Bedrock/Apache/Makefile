# ident "@(#) $Header$"
# ident "@(#)        $Name$"
#
# Name of Release: $Name$
# $Log$
# Revision 1.1  2000/12/12 19:02:36  sridhar
# Makefile for Bedrock clients: mod_perl handler and the CGI version
#
#

include ../make.pre

     CURRENT_PATH = Apache

          TARGETS = Bedrock.pm Request_cgi.pm bedrock.cgi

all: $(TARGETS)

install:: $(TARGETS:%=%-install)

bedrock.cgi-install::
	$(INSTALL) $(@:-install=)	$(CGIBINDIR)

include ../make.post
