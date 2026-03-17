#-*- mode: makefile; -*-
SUBDIRS = .

RELEASE_FILES := $(wildcard RELEASE-NOTES*.md)

notesdir = $(datadir)/bedrock/release-notes

all:	$(RELEASE_FILES)
	echo $(RELEASE_FILES)

dist_notes_DATA = $(RELEASE_FILES)

