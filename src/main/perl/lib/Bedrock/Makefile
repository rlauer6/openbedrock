# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
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

          TARGETS = 

all install:
	cd PDF		&& $(MAKE) $@
	cd Text		&& $(MAKE) $@
	cd SIS		&& $(MAKE) $@

include ../make.post
