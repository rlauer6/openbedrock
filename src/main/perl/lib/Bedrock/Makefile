# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.9  2000/12/15 18:48:58  sridhar
# Improved makefile with more usage of rules.
#
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

          TARGETS = XML.pm VERSION.pm

      TARGET_DIRS = PDF Text SIS BLM XML Apache

all: $(TARGETS) $(TARGET_DIRS)

install:: $(TARGETS:%=%-install) $(TARGET_DIRS:%=%-install)

$(TARGET_DIRS)::
	cd $@		&& $(MAKE) all

$(TARGET_DIRS:%=%-install)::
	cd $(@:-install=)       && $(MAKE) install

include ../make.post
