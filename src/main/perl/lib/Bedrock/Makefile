# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.8  2000/11/01 18:37:44  sridhar
# Adding XML capability to Bedrock. Basically we have a class here which
# can read and write arbitrary perl data structures in XML format.
#
# Revision 1.7  2000/09/18 18:50:05  sridhar
# Some BLMs moved from Perl/BLM and Perl/BLM/Startup to Perl/Bedrock/BLM
# and Perl/Bedrock/BLM/Startup
#
# Revision 1.6  2000/09/18 15:18:56  sridhar
# Had forgotten to add SIS directory
#
# Revision 1.5  2000/09/18 14:19:28  sridhar
# Moved Perl/Text to Perl/Bedrock/Text
#
# Revision 1.4  2000/09/15 14:27:23  sridhar
# Adding Bedrock/Makefile
#
#

include ../make.pre

     CURRENT_PATH = Bedrock

          TARGETS = XML.pm

all: PDF Text SIS BLM XML

PDF::
	cd $@		&& $(MAKE) all

Text::
	cd $@		&& $(MAKE) all

SIS::
	cd $@		&& $(MAKE) all

BLM::
	cd $@		&& $(MAKE) all

XML::
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) XML.pm
	cd $@		&& $(MAKE) all

PDF-install Text-install SIS-install BLM-install::
	cd $(@:%-install=%)		&& $(MAKE) install

XML-install::
	$(INSTALL) XML.pm	$(CURRENT_TARGET)
	cd $(@:%-install=%)	&& $(MAKE) install

install: PDF-install Text-install SIS-install BLM-install XML-install

include ../make.post
