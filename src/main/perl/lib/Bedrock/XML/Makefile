# ident "@(#) $Header$"
# ident "@(#)        $Name$"
#
# Name of Release: $Name$
# $Log$
# Revision 1.1  2000/11/01 18:37:49  sridhar
# Adding XML capability to Bedrock. Basically we have a class here which
# can read and write arbitrary perl data structures in XML format.
#
#

include ../make.pre

     CURRENT_PATH = XML

          TARGETS = Container.pm

all: Container

Container::
	$(PERL) $(PERLINCLUDES) $(PERLFLAGS) Container.pm
	cd $@		&& $(MAKE) all

install: Container-install

Container-install::
	$(INSTALL) Container.pm	$(CURRENT_TARGET)
	cd $(@:%-install=%)	&& $(MAKE) install

include ../make.post
