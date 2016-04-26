## Process this file with automake to produce Makefile.in   -*-Makefile-*-
PERL = @PERL@

perl5libdir = @PERL_LIBDIR@

perl5bedrocklibdir             		  = $(perl5libdir)/Bedrock

perl5bedrockhtmllibdir             	  = $(perl5libdir)/Bedrock/HTML
perl5bedrockinputsourcelibdir          	  = $(perl5libdir)/Bedrock/InputSource
perl5bedrockapachelibdir       		  = $(perl5libdir)/Bedrock/Apache
perl5bedrockapplicationlibdir       	  = $(perl5libdir)/Bedrock/Application
perl5bedrockcontextlibdir      		  = $(perl5libdir)/Bedrock/Context
perl5bedrocktextlibdir         		  = $(perl5libdir)/Bedrock/Text
perl5bedrocktexttagxlibdir     		  = $(perl5libdir)/Bedrock/Text/TagX
perl5bedrocktexttagxtaglibdir  		  = $(perl5libdir)/Bedrock/Text/TagX/TAG
perl5bedrocktexttagxtagnobodylibdir   	  = $(perl5libdir)/Bedrock/Text/TagX/TAG/NoBody
perl5bedrocktexttagxtagwithbodylibdir 	  = $(perl5libdir)/Bedrock/Text/TagX/TAG/WithBody
perl5bedrocktexttagxtagwithbodyiflibdir   = $(perl5libdir)/Bedrock/Text/TagX/TAG/WithBody/If
perl5bedrocktexttagxtagwithbodylooplibdir = $(perl5libdir)/Bedrock/Text/TagX/TAG/WithBody/Loop
perl5bedrocktexttagxtermlibdir 		  = $(perl5libdir)/Bedrock/Text/TagX/Term
perl5bedrockxmllibdir          		  = $(perl5libdir)/Bedrock/XML
perl5bedrockyamllibdir         		  = $(perl5libdir)/Bedrock/YAML
perl5bedrockcsvlibdir         		  = $(perl5libdir)/Bedrock/CSV
perl5bedrockbedrockxmllibdir     	  = $(perl5libdir)/Bedrock/BedrockXML
perl5bedrockjsonlibdir         		  = $(perl5libdir)/Bedrock/JSON
perl5bedrockxmlcontainerlibdir 		  = $(perl5libdir)/Bedrock/XML/Container

perl5blmlibdir                    = $(perl5libdir)/BLM
perl5blmfilterlibdir              = $(perl5libdir)/BLM/Filter
perl5blmindexedtablehandlerlibdir = $(perl5libdir)/BLM/IndexedTableHandler
perl5blmstartuplibdir 	          = $(perl5libdir)/BLM/Startup
perl5blmstartupsessionlibdir      = $(perl5libdir)/BLM/Startup/Session

perl5testlibdir                   = $(perl5libdir)/Test
perl5testlib_DATA = \
    Test/Bedrock.pm

TEST_BEDROCK=$(perl5testlib_DATA:.pm=.pm.in)

perl5lib_DATA = \
    Bedrock.pm \
    bedrock_handler_common.pm

perl5bedrocklib_DATA = \
    Bedrock/BedrockConfig.pm \
    Bedrock/Context.pm \
    Bedrock/BedrockCGI.pm \
    Bedrock/VERSION.pm \
    Bedrock/XML.pm \
    Bedrock/Array.pm \
    Bedrock/BufferStream.pm \
    Bedrock/Dump.pm \
    Bedrock/Handle.pm \
    Bedrock/Handler.pm \
    Bedrock/Hash.pm \
    Bedrock/InputSource.pm \
    Bedrock/BedrockJSON.pm \
    Bedrock/Log.pm \
    Bedrock/Plugin.pm \
    Bedrock/Serializer.pm \
    Bedrock/Snippet.pm \
    Bedrock/Template.pm

BEDROCK=$(perl5bedrocklib_DATA:.pm=.pm.in)

perl5bedrockapplicationlib_DATA = \
    Bedrock/Application/Plugin.pm

BEDROCK_APPLICATION=$(perl5bedrockapplicationlib_DATA:.pm=.pm.in)

perl5bedrockapachelib_DATA = \
    Bedrock/Apache/Bedrock.pm \
    Bedrock/Apache/bedrock.pl \
    Bedrock/Apache/bedrock_sh.pl \
    Bedrock/Apache/Request_cgi.pm \
    Bedrock/Apache/Request_shell.pm \
    Bedrock/Apache/BedrockAutocomplete.pm \
    Bedrock/Apache/BedrockSessionFiles.pm \
    Bedrock/Apache/BedrockDocs.pm \
    Bedrock/Apache/BedrockModPerl.pm

BEDROCK_APACHE=$(perl5bedrockapachelib_DATA:.pm=.pm.in)

perl5bedrockcontextlib_DATA = \
    Bedrock/Context/Shell.pm

BEDROCK_CONTEXT=$(perl5bedrockcontextlib_DATA:.pm=.pm.in)

perl5bedrockhtmllib_DATA = \
    Bedrock/HTML/Helper.pm

BEDROCK_HTML=$(perl5bedrockhtmllib_DATA:.pm=.pm.in)

perl5blmfilterlib_DATA = \
    BLM/Filter/crypt.pm \
    BLM/Filter/csv.pm \
    BLM/Filter/xls.pm

BEDROCK_FILTER=$(perl5blmfilterlib_DATA:.pm=.pm.in)

perl5bedrockinputsourcelib_DATA = \
    Bedrock/InputSource/Term.pm

BEDROCK_INPUTSOURCE=$(perl5bedrockinputsourcelib_DATA:.pm=.pm.in)

perl5bedrocktextlib_DATA = \
    Bedrock/Text/TagX.pm \
    Bedrock/Text/URLEncode.pm

BEDROCK_TEXT=$(perl5bedrocktextlib_DATA:.pm=.pm.in)

perl5bedrocktexttagxlib_DATA = \
    Bedrock/Text/TagX/Error.pm \
    Bedrock/Text/TagX/Expr.pm \
    Bedrock/Text/TagX/Func.pm \
    Bedrock/Text/TagX/Log.pm \
    Bedrock/Text/TagX/Output.pm \
    Bedrock/Text/TagX/Parser.pm \
    Bedrock/Text/TagX/Scalar.pm \
    Bedrock/Text/TagX/Symtab.pm \
    Bedrock/Text/TagX/TAG.pm \
    Bedrock/Text/TagX/Term.pm

BEDROCK_TEXT_TAGX=$(perl5bedrocktexttagxlib_DATA:.pm=.pm.in)

perl5bedrocktexttagxtaglib_DATA = \
    Bedrock/Text/TagX/TAG/NoBody.pm \
    Bedrock/Text/TagX/TAG/WithBody.pm \
    Bedrock/Text/TagX/TAG/SQLHandler.pm

BEDROCK_TEXT_TAGX_TAG=$(perl5bedrocktexttagxtaglib_DATA:.pm=.pm.in)

perl5bedrocktexttagxtagnobodylib_DATA = \
    Bedrock/Text/TagX/TAG/NoBody/Array.pm \
    Bedrock/Text/TagX/TAG/NoBody/Comment.pm \
    Bedrock/Text/TagX/TAG/NoBody/Plugin.pm \
    Bedrock/Text/TagX/TAG/NoBody/Case.pm \
    Bedrock/Text/TagX/TAG/NoBody/Exec.pm \
    Bedrock/Text/TagX/TAG/NoBody/Hash.pm \
    Bedrock/Text/TagX/TAG/NoBody/Include.pm \
    Bedrock/Text/TagX/TAG/NoBody/Iif.pm \
    Bedrock/Text/TagX/TAG/NoBody/Flush.pm \
    Bedrock/Text/TagX/TAG/NoBody/NULL.pm \
    Bedrock/Text/TagX/TAG/NoBody/Open.pm \
    Bedrock/Text/TagX/TAG/NoBody/Pebble.pm \
    Bedrock/Text/TagX/TAG/NoBody/Raise.pm \
    Bedrock/Text/TagX/TAG/NoBody/RecordSet.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQL.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQLCommit.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQLRollback.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQLConnect.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQLTable.pm \
    Bedrock/Text/TagX/TAG/NoBody/Trace.pm \
    Bedrock/Text/TagX/TAG/NoBody/Var.pm

BEDROCK_TEXT_TAGX_TAG_NOBODY=$(perl5bedrocktexttagxtagnobodylib_DATA:.pm=.pm.in)

perl5bedrocktexttagxtagwithbodylib_DATA = \
    Bedrock/Text/TagX/TAG/WithBody/Cache.pm \
    Bedrock/Text/TagX/TAG/WithBody/Catch.pm \
    Bedrock/Text/TagX/TAG/WithBody/If.pm \
    Bedrock/Text/TagX/TAG/WithBody/Unless.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop.pm \
    Bedrock/Text/TagX/TAG/WithBody/NoExec.pm \
    Bedrock/Text/TagX/TAG/WithBody/PebbleDef.pm \
    Bedrock/Text/TagX/TAG/WithBody/Sink.pm \
    Bedrock/Text/TagX/TAG/WithBody/Snippet.pm \
    Bedrock/Text/TagX/TAG/WithBody/Try.pm

BEDROCK_TEXT_TAGX_TAG_WITHBODY=$(perl5bedrocktexttagxtagwithbodylib_DATA:.pm=.pm.in)

perl5bedrocktexttagxtagwithbodyiflib_DATA = \
    Bedrock/Text/TagX/TAG/WithBody/If/Else.pm

BEDROCK_TEXT_TAGX_TAG_WITHBODY_IF=$(perl5bedrocktexttagxtagwithbodyiflib_DATA:.pm=.pm.in)

perl5bedrocktexttagxtagwithbodylooplib_DATA = \
    Bedrock/Text/TagX/TAG/WithBody/Loop/Foreach.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop/SQLSelect.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop/While.pm

BEDROCK_TEXT_TAGX_TAG_WITHBODY_LOOP=$(perl5bedrocktexttagxtagwithbodylooplib_DATA:.pm=.pm.in)

perl5bedrocktexttagxtermlib_DATA = \
    Bedrock/Text/TagX/Term/String.pm \
    Bedrock/Text/TagX/Term/Var.pm

BEDROCK_TEXT_TAGX_TERM=$(perl5bedrocktexttagxtermlib_DATA:.pm=.pm.in)

perl5bedrockxmllib_DATA = \
    Bedrock/XML/Container.pm \
    Bedrock/XML/Handler.pm

BEDROCK_XML=$(perl5bedrockxmllib_DATA:.pm=.pm.in)

perl5bedrockyamllib_DATA = \
    Bedrock/YAML/Handler.pm

BEDROCK_YAML=$(perl5bedrockyamllib_DATA:.pm=.pm.in)

perl5bedrockcsvlib_DATA = \
    Bedrock/CSV/Handler.pm

BEDROCK_CSV=$(perl5bedrockcsvlib_DATA:.pm=.pm.in)

perl5bedrockbedrockxmllib_DATA = \
    Bedrock/BedrockXML/Handler.pm

BEDROCK_BEDROCKXML=$(perl5bedrockbedrockxmllib_DATA:.pm=.pm.in)

perl5bedrockjsonlib_DATA = \
    Bedrock/JSON/Handler.pm

BEDROCK_JSON=$(perl5bedrockjsonlib_DATA:.pm=.pm.in)

perl5bedrockxmlcontainerlib_DATA = \
    Bedrock/XML/Container/Array.pm \
    Bedrock/XML/Container/Object.pm \
    Bedrock/XML/Container/Scalar.pm

BEDROCK_XML_CONTAINER=$(perl5bedrockxmlcontainerlib_DATA:.pm=.pm.in)

# Plugins
# -------

perl5blmindexedtablehandlerlib_DATA = \
    BLM/IndexedTableHandler/RecordSet.pm \
    BLM/IndexedTableHandler/Common.pm

BLM_INDEXEDTABLEHANDLER=$(perl5blmindexedtablehandlerlib_DATA:.pm=.pm.in)

perl5blmlib_DATA = \
    BLM/Awk.pm \
    BLM/Benchmark.pm \
    BLM/Date.pm \
    BLM/DBHandler.pm \
    BLM/FileIO.pm \
    BLM/IndexedTableHandler.pm \
    BLM/Mail.pm \
    BLM/Recycle.pm \
    BLM/FTP.pm \
    BLM/SMTP.pm \
    BLM/Session.pm \
    BLM/Stat.pm \
    BLM/Timenow.pm

BLM=$(perl5blmlib_DATA:.pm=.pm.in)

perl5blmstartuplib_DATA = \
    BLM/Startup/Bedrock.pm \
    BLM/Startup/Config.pm \
    BLM/Startup/Cookie.pm \
    BLM/Startup/Env.pm \
    BLM/Startup/Forum.pm \
    BLM/Startup/Header.pm \
    BLM/Startup/Hitcounter.pm \
    BLM/Startup/Input.pm \
    BLM/Startup/MySQLSession.pm \
    BLM/Startup/OAuth2.pm \
    BLM/Startup/Output.pm \
    BLM/Startup/PostgreSQLSession.pm \
    BLM/Startup/SQLiteSession.pm \
    BLM/Startup/Session.pm \
    BLM/Startup/SessionManager.pm \
    BLM/Startup/SQLSession.pm \
    BLM/Startup/UserSession.pm 

BLM_STARTUP=$(perl5blmstartuplib_DATA:.pm=.pm.in)

perl5blmstartupsessionlib_DATA = \
    BLM/Startup/Session/GDBM.pm \
    BLM/Startup/Session/SDBM.pm

BLM_STARTUP_SESSION=$(perl5blmstartupsessionlib_DATA:.pm=.pm.in)

dist_noinst_DATA = \
    Bedrock.pm.in \
    bedrock_handler_common.pm.in \
    $(BEDROCK) \
    $(BEDROCK_APPLICATION) \
    $(BEDROCK_APACHE) \
    $(BEDROCK_CONTEXT) \
    $(BEDROCK_HTML) \
    $(BEDROCK_FILTER) \
    $(BEDROCK_INPUTSOURCE) \
    $(BEDROCK_TEXT) \
    $(BEDROCK_TEXT_TAGX) \
    $(BEDROCK_TEXT_TAGX_TAG) \
    $(BEDROCK_TEXT_TAGX_TAG_NOBODY) \
    $(BEDROCK_TEXT_TAGX_TAG_WITHBODY) \
    $(BEDROCK_TEXT_TAGX_TAG_WITHBODY_IF) \
    $(BEDROCK_TEXT_TAGX_TAG_WITHBODY_LOOP) \
    $(BEDROCK_TEXT_TAGX_TERM) \
    $(BEDROCK_XML) \
    $(BEDROCK_YAML) \
    $(BEDROCK_CSV) \
    $(BEDROCK_BEDROCKXML) \
    $(BEDROCK_JSON) \
    $(BEDROCK_XML_CONTAINER) \
    $(BLM_INDEXEDTABLEHANDLER) \
    $(BLM) \
    $(BLM_STARTUP) \
    $(BLM_STARTUP_SESSION) \
    $(TEST_BEDROCK)

@do_subst_command@

SUFFIXES = .tdy .in .pm .pm.in

%.pm: %.pm.in
	test -d "$$(dirname "$@")" || $(INSTALL) -d "$$(dirname "$@")"
	$(do_subst) $< > $@

TIDY = $(dist_noinst_DATA:.pm.in=.pm.in.tdy)

tidy: $(TIDY)

$(TIDY): %.in.tdy : %
	test -e $<.in && perltidy -vt=2 -pt=1 -dws -i=2 -lp -ci=0 -cti=1 $<.in || true
	test -e $@ && cp $@ $<.in && touch $@ || true

clean-local:
	find . -name '*.pm' -exec rm {} \;
	rm -rf *.tdy

test:
	$(PROVE) -v -I . -I Bedrock -I Bedrock/Text t
