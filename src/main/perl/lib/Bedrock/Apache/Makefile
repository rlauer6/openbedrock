# ident "@(#) $Header$"
# ident "@(#)        $Name$"
#
# Name of Release: $Name$
# $Log$
# Revision 1.2  2000/12/18 18:05:57  sridhar
# 1. Added PDFrock.pm and pdfrock.pl
# 2. Improved makefile uses target for making CGIs properly.
#
# Revision 1.1  2000/12/12 19:02:36  sridhar
# Makefile for Bedrock clients: mod_perl handler and the CGI version
#
#

include ../make.pre

     CURRENT_PATH = Apache

          TARGETS = Bedrock.pm Request_cgi.pm PDFrock.pm

      CGI_TARGETS = bedrock.cgi pdfrock.cgi

all: $(TARGETS) $(CGI_TARGETS)

install:: $(TARGETS:%=%-install) $(CGI_TARGETS:%=%-install)

include ../make.post
