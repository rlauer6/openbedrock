# ident "@(#) $Header$"
# ident "@(#)        $Name$"
# 
# $Log$
# Revision 1.10  2002/10/24 16:42:18  rlauer
# - FileIO.pm
#
# Revision 1.9  2001/02/15 13:52:38  sridhar
# Moved List.pm to OrderedObject.pm
#
# Revision 1.8  2000/12/11 15:49:04  sridhar
# Moved out some common defns/rules to include file.
#
# Revision 1.7  2000/12/01 15:10:27  sridhar
# Added List.pm and cleaned up the Makefile a lot.
#
# Revision 1.6  2000/10/26 20:43:12  rlauer
# - added SIMPLEFTP
#
# Revision 1.5  2000/10/19 20:52:05  sridhar
# Added SMTP.pm
#
# Revision 1.4  2000/09/29 19:15:37  sridhar
# Added Stat.pm
#
# Revision 1.3  2000/09/27 15:35:03  sridhar
# Added Recycle.pm
#
# Revision 1.2  2000/09/25 20:17:36  sridhar
# Added Benchmark.pm and String.pm
#
# Revision 1.1  2000/09/18 18:50:05  sridhar
# Some BLMs moved from Perl/BLM and Perl/BLM/Startup to Perl/Bedrock/BLM
# and Perl/Bedrock/BLM/Startup
#
# Revision 1.10  2000/09/15 13:24:47  sridhar
# Added Perldoc.pm
#
# Revision 1.9  2000/09/14 22:32:54  rlauer
# - added BLM::Number
# 	BLM::String
# 	BLM::Series
#
# Revision 1.8  2000/09/08 14:14:39  sridhar
# Added Search.pm and Abstract.pm and Search directory
#
# Revision 1.7  2000/08/11 13:33:16  sridhar
# Added BLM::Array
#
# Revision 1.6  2000/07/18 19:23:45  sridhar
# Oops! forgot a leftover Calendar.pm
#
# Revision 1.5  2000/07/18 19:22:43  sridhar
# Removed Calendar.pm and Modules.pm
#
# Revision 1.4  2000/07/18 19:20:34  sridhar
# Added Fortune and Date
#
# Revision 1.3  2000/07/12 19:40:52  rlauer
# Initial check-in of Calendar BLM.
#
# Revision 1.2  2000/06/22 14:31:08  rlauer
# added Mail.pm
#
# Revision 1.1  2000/06/07 18:03:44  sridhar
# Making and installing BLMs
#
#

include ../make.pre

     CURRENT_PATH = BLM

          TARGETS = Timenow.pm File.pm Keys.pm Awk.pm Mail.pm Include.pm Fortune.pm \
		    Date.pm Array.pm Number.pm Series.pm Perldoc.pm Benchmark.pm String.pm \
		    Recycle.pm Stat.pm SMTP.pm SIMPLEFTP.pm OrderedObject.pm FileIO.pm

all: $(TARGETS)
	cd Startup && $(MAKE) $@

install:: $(TARGETS:%=%-install)
	cd Startup && $(MAKE) $@

include ../make.post
