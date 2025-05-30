#-*- mode: makefile; -*-

########################################################################
# Bedrock - configuration files that will be installed into images
########################################################################
XML_FILES = \
   mysql-session.xml.in \
   data-sources.xml.in \
   redis-session.xml.in \
   redis.xml.in

GXML_FILES = $(XML_FILES:.xml.in=.xml)
CONFIG_FILES += $(GXML_FILES)

$(GXML_FILES): % : %.in
	$(do_subst) $< > $@

TAGX = \
  tagx.xml.in

GTAGX = $(TAGX:.xml.in=.xml)
CONFIG_FILES += $(GTAGX)

LOGFILE := $(shell \
  if [ -n "$$STREAM_LOGS" ]; then \
    echo STDERR; \
  else \
    echo bedrock.log; \
  fi)

HTML_LOGFILE := $(shell \
  if [ -n "$$STREAM_LOGS" ]; then \
    echo STDERR; \
  fi)

$(GTAGX): % : %.in
	$(do_subst) $< | \
	sed -e 's,@logfile@,'$(LOGFILE)',' \
	    -e 's,@html_logfile@,'$(HTML_LOGFILE)',' >$@
