#-*- mode: makefile; -*-

BEDROCK_VERSION = @PACKAGE_VERSION@

.PHONY: bedrock
bedrock: $(top_srcdir)/bedrock-$(BEDROCK_VERSION).tar.gz

########################################################################
# make distcheck - ensures that the distribution is complete
########################################################################
$(top_srcdir)/bedrock-$(BEDROCK_VERSION).tar.gz:
	cd $(top_srcdir); \
	$(MAKE) distcheck

########################################################################
# make cpan - creates a CPAN distribution
########################################################################
$(top_srcdir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz: $(top_srcdir)/bedrock-$(BEDROCK_VERSION).tar.gz
	cd $(top_srcdir)/cpan; \
	make cpan

########################################################################
# copies the Bedrock distribution to the Docker context
########################################################################
Bedrock-$(BEDROCK_VERSION).tar.gz: $(top_srcdir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz
	cp $(top_srcdir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz Bedrock-$(BEDROCK_VERSION).tar.gz
