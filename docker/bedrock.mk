#-*- mode: makefile; -*-

BEDROCK_VERSION = @PACKAGE_VERSION@

.PHONY: bedrock
bedrock: $(top_srcdir)/bedrock-$(BEDROCK_VERSION).tar.gz

########################################################################
# make distcheck - ensures that the distribution is complete
########################################################################

ensure-clean-build:
	@if [ "$$BEDROCK_BUILD_CHECK_RUNNING" = "1" ]; then \
	  echo "Already running ensure-clean-build — skipping recursion"; \
	else \
	  echo "Running top-level ensure-clean-build..."; \
	  BEDROCK_BUILD_CHECK_RUNNING=1 $(MAKE) -C $(top_builddir) ensure-clean-build-from-top; \
	fi

$(top_builddir)/bedrock-$(BEDROCK_VERSION).tar.gz: ensure-clean-build

########################################################################
# make cpan - creates a CPAN distribution
########################################################################
$(top_builddir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz: $(top_builddir)/bedrock-$(BEDROCK_VERSION).tar.gz
	cd $(top_builddir)/cpan; \
	make cpan

########################################################################
# copies the Bedrock distribution to the Docker context
########################################################################
Bedrock-$(BEDROCK_VERSION).tar.gz: $(top_builddir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz
	cp $(top_builddir)/cpan/Bedrock-$(BEDROCK_VERSION).tar.gz Bedrock-$(BEDROCK_VERSION).tar.gz
