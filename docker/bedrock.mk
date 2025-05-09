#-*- mode: makefile; -*-

BEDROCK_VERSION = @PACKAGE_VERSION@

########################################################################
# make cpan - creates a CPAN distribution
########################################################################
$(top_builddir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz: bedrock.md5sum
	$(MAKE) -C $(top_builddir)/cpan cpan

########################################################################
# copies the Bedrock distribution to the Docker context
########################################################################
$(TARBALL): $(top_builddir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz
	cp $(top_builddir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz $@


