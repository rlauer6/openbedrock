## Process this file with automake to produce Makefile.in   -*-Makefile-*-

SUBDIRS = lib \
          bin \
          cgi-bin \
          .

test:
	prove $(PROVE_ARGS) -Ilib{,/Bedrock,/Bedrock/Text} t
