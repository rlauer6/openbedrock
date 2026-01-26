# -*-Makefile-*-
PERL = @PERL@

check_SCRIPTS = prove.sh

TESTS = $(check_SCRIPTS)

TEST_LOG_DRIVER = env AM_TAP_AWK='$(AWK)' $(SHELL) \
              $(top_srcdir)/autotools/tap-driver.sh

BEDROCK_RELEASE = @BEDROCK_RELEASE@

perl5libdir = @PERL_LIBDIR@

perl5bedrocklibdir             		  = $(perl5libdir)/Bedrock

perl5bedrockapachelibdir       		  = $(perl5libdir)/Bedrock/Apache
perl5bedrockapacherequestlibdir           = $(perl5libdir)/Bedrock/Apache/Request
perl5bedrockapplicationlibdir       	  = $(perl5libdir)/Bedrock/Application
perl5bedrockcachelibdir    	          = $(perl5libdir)/Bedrock/Cache
perl5bedrockcontextlibdir      		  = $(perl5libdir)/Bedrock/Context
perl5bedrockhtmllibdir             	  = $(perl5libdir)/Bedrock/HTML
perl5bedrockloglibdir      		  = $(perl5libdir)/Bedrock/Log
perl5bedrockdbilibdir      		  = $(perl5libdir)/Bedrock/DBI
perl5bedrockrequestlibdir      		  = $(perl5libdir)/Bedrock/Request

perl5bedrockminiserverlibdir              = $(perl5libdir)/Bedrock/MiniServer
perl5bedrockmodellibdir                   = $(perl5libdir)/Bedrock/Model
perl5bedrockmodelserializerlibdir         = $(perl5libdir)/Bedrock/Model/Serializer
perl5bedrockmodelreservedwordslibdir      = $(perl5libdir)/Bedrock/Model/ReservedWords

perl5bedrockrolelibdir    	          = $(perl5libdir)/Bedrock/Role
perl5bedrockservicelibdir    		  = $(perl5libdir)/Bedrock/Service
perl5bedrocktemplatelibdir    		  = $(perl5libdir)/Bedrock/Template
perl5bedrocktestlibdir         		  = $(perl5libdir)/Bedrock/Test
perl5bedrocktextlibdir         		  = $(perl5libdir)/Bedrock/Text
perl5bedrocktexttagxlibdir     		  = $(perl5libdir)/Bedrock/Text/TagX
perl5bedrocktexttagxtaglibdir  		  = $(perl5libdir)/Bedrock/Text/TagX/TAG
perl5bedrocktexttagxtagnobodylibdir   	  = $(perl5libdir)/Bedrock/Text/TagX/TAG/NoBody
perl5bedrocktexttagxtagwithbodylibdir 	  = $(perl5libdir)/Bedrock/Text/TagX/TAG/WithBody
perl5bedrocktexttagxtagwithbodyiflibdir   = $(perl5libdir)/Bedrock/Text/TagX/TAG/WithBody/If
perl5bedrocktexttagxtagwithbodylooplibdir = $(perl5libdir)/Bedrock/Text/TagX/TAG/WithBody/Loop
perl5bedrocktexttagxtermlibdir 		  = $(perl5libdir)/Bedrock/Text/TagX/Term
perl5bedrockserializerlibdir         	  = $(perl5libdir)/Bedrock/Serializer
perl5bedrockxmllibdir			  = $(perl5libdir)/Bedrock/XML
perl5bedrockxmlcontainerlibdir 		  = $(perl5libdir)/Bedrock/XML/Container

perl5blmlibdir                           = $(perl5libdir)/BLM
perl5blmfilterlibdir                     = $(perl5libdir)/BLM/Filter
perl5blmindexedtablehandlerlibdir        = $(perl5libdir)/BLM/IndexedTableHandler
perl5blmstartuplibdir 	                 = $(perl5libdir)/BLM/Startup
perl5blmstartupsessionlibdir             = $(perl5libdir)/BLM/Startup/Session

perl5bedrockloglib_DATA =

perl5bedrockdbilib_DATA = \
   Bedrock/DBI/Utils.pm \
   Bedrock/DBI/Locator.pm

BEDROCK_DBI=$(perl5bedrockdbilib_DATA:.pm=.pm.in)

perl5bedrockrequestlib_DATA = \
   Bedrock/Request/Upload.pm

perl5bedrockcachelib_DATA = \
   Bedrock/Cache/Engine.pm \
   Bedrock/Cache/Redis.pm \
   Bedrock/Cache/Memory.pm \
   Bedrock/Cache/Null.pm \
   Bedrock/Cache/Shareable.pm

BEDROCK_CACHE = $(perl5bedrockcachelib_DATA:.pm=.pm.in)

perl5lib_DATA = \
    Bedrock.pm \
    bedrock_handler_common.pm

perl5bedrocklib_DATA = \
    Bedrock/Application.pm \
    Bedrock/Array.pm \
    Bedrock/BedrockCGI.pm \
    Bedrock/BedrockConfig.pm \
    Bedrock/BedrockJSON.pm \
    Bedrock/BufferStream.pm \
    Bedrock/Cache.pm \
    Bedrock/Context.pm \
    Bedrock/Constants.pm \
    Bedrock/CSRF.pm \
    Bedrock/Dump.pm \
    Bedrock/Dumper.pm \
    Bedrock/Error.pm \
    Bedrock/Exception.pm \
    Bedrock/Handle.pm \
    Bedrock/Handler.pm \
    Bedrock/Hash.pm \
    Bedrock/Install.pm \
    Bedrock/LoadConfig.pm \
    Bedrock/Logger.pm \
    Bedrock/Log.pm \
    Bedrock/Model.pm \
    Bedrock/Object.pm \
    Bedrock/Pager.pm \
    Bedrock/Plugin.pm \
    Bedrock/PodWriter.pm \
    Bedrock/RegExp.pm \
    Bedrock/Request.pm \
    Bedrock/Router.pm \
    Bedrock/Serializer.pm \
    Bedrock/Service.pm \
    Bedrock/Snippet.pm \
    Bedrock/Test.pm \
    Bedrock/Template.pm \
    Bedrock/VERSION.pm \
    Bedrock/XML.pm

BEDROCK=$(perl5bedrocklib_DATA:.pm=.pm.in)

perl5bedrocktestlib_DATA = \
    Bedrock/Test/FauxContext.pm \
    Bedrock/Test/FauxHandler.pm \
    Bedrock/Test/FauxLogger.pm \
    Bedrock/Test/Utils.pm

BEDROCK_TEST=$(perl5bedrocktestlib_DATA:.pm=.pm.in)

perl5bedrocktemplatelib_DATA = \
    Bedrock/Template/Email.pm

BEDROCK_TEMPLATE=$(perl5bedrocktemplatelib_DATA:.pm=.pm.in)

BEDROCK_LOG=$(perl5bedrockloglib_DATA:.pm=.pm.in)


BEDROCK_POD=$(perl5bedrockpodlib_DATA:.pm=.pm.in)

perl5bedrockapplicationlib_DATA = \
    Bedrock/Application/Plugin.pm

BEDROCK_APPLICATION=$(perl5bedrockapplicationlib_DATA:.pm=.pm.in)

perl5bedrockapachelib_DATA = \
    $(BEDROCK_APACHE:.pm.in=.pm)

BEDROCK_APACHE = \
    Bedrock/Apache/Bedrock.pm.in \
    Bedrock/Apache/BedrockAuthenticate.pm.in \
    Bedrock/Apache/BedrockAutocomplete.pm.in \
    Bedrock/Apache/BedrockDocs.pm.in \
    Bedrock/Apache/BedrockForm.pm.in \
    Bedrock/Apache/BedrockModPerl.pm.in \
    Bedrock/Apache/BedrockSessionFiles.pm.in \
    Bedrock/Apache/Constants.pm.in \
    Bedrock/Apache/HandlerUtils.pm.in

perl5bedrockapacherequestlib_DATA = \
    $(BEDROCK_APACHE_REQUEST:.pm.in=.pm)

BEDROCK_APACHE_REQUEST = \
    Bedrock/Apache/Request/CGI.pm.in \
    Bedrock/Apache/Request/Shell.pm.in

BEDROCK_REQUEST = \
    Bedrock/Request.pm \
    Bedrock/Request/Upload.pm

perl5bedrockhtmllib_DATA = \
    Bedrock/HTML/Helper.pm

BEDROCK_HTML=$(perl5bedrockhtmllib_DATA:.pm=.pm.in)

perl5blmfilterlib_DATA = \
    BLM/Filter/crypt.pm \
    BLM/Filter/csv.pm \
    BLM/Filter/xls.pm

BEDROCK_FILTER=$(perl5blmfilterlib_DATA:.pm=.pm.in)

perl5bedrocktextlib_DATA = \
    Bedrock/Text/TagX.pm \
    Bedrock/Text/URLEncode.pm

BEDROCK_TEXT=$(perl5bedrocktextlib_DATA:.pm=.pm.in)

BEDROCK_REDIS=$(perl5bedrockredisclientlib_DATA:.pm=.pm.in)

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
    Bedrock/Text/TagX/TAG/SQLHandler.pm \
    Bedrock/Text/TagX/TAG/SQLConnector.pm

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
    Bedrock/Text/TagX/TAG/WithBody/Container.pm \
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
    Bedrock/XML/Container.pm

BEDROCK_XML=$(perl5bedrockxmllib_DATA:.pm=.pm.in)

BEDROCK_ROLE=$(perl5bedrockrolelib_DATA:.pm=.pm.in)

BEDROCK_SERVICE=$(perl5bedrockservicelib_DATA:.pm=.pm.in)

perl5bedrockrolelib_DATA = \
    Bedrock/Role/Config.pm \
    Bedrock/Role/DocFinder.pm

perl5bedrockservicelib_DATA = \
    Bedrock/Service/Docs.pm \
    Bedrock/Service/Autocomplete.pm

perl5bedrockserializerlib_DATA = \
    Bedrock/Serializer/CSV.pm         \
    Bedrock/Serializer/BedrockXML.pm  \
    Bedrock/Serializer/JSON.pm        \
    Bedrock/Serializer/XML.pm         \
    Bedrock/Serializer/YAML.pm

BEDROCK_SERIALIZER = $(perl5bedrockserializerlib_DATA:.pm=.pm.in)

perl5bedrockminiserverlib_DATA = \
    Bedrock/MiniServer/Context.pm

BEDROCK_MINISERVER = $(perl5bedrockminiserverlib_DATA:.pm=.pm.in)

perl5bedrockxmlcontainerlib_DATA = \
    Bedrock/XML/Container/Array.pm \
    Bedrock/XML/Container/Object.pm \
    Bedrock/XML/Container/Scalar.pm

BEDROCK_XML_CONTAINER=$(perl5bedrockxmlcontainerlib_DATA:.pm=.pm.in)

# Bedrock Model
# -------------

perl5blmindexedtablehandlerlib_DATA = \
    BLM/IndexedTableHandler/RecordSet.pm \
    BLM/IndexedTableHandler/Form.pm \
    BLM/IndexedTableHandler/Common.pm

BLM_INDEXEDTABLEHANDLER=$(perl5blmindexedtablehandlerlib_DATA:.pm=.pm.in)

# Bedrock/Model
perl5bedrockmodellib_DATA = \
    Bedrock/Model/Field.pm \
    Bedrock/Model/Migration.pm \
    Bedrock/Model/Handler.pm \
    Bedrock/Model/Importer.pm \
    Bedrock/Model/Maker.pm \
    Bedrock/Model/ReservedWords.pm \
    Bedrock/Model/Role.pm

BEDROCK_MODEL=$(perl5bedrockmodellib_DATA:.pm=.pm.in)


# Bedrock/Model/ReservedWords
perl5bedrockmodelreservedwordslib_DATA = \
    Bedrock/Model/ReservedWords/MySQL.pm

BEDROCK_MODEL_RESERVEDWORDS=$(perl5bedrockmodelreservedwordslib_DATA:.pm=.pm.in)


# Bedrock/Model/Serializer
perl5bedrockmodelserializerlib_DATA = \
    Bedrock/Model/Serializer/MySQL.pm

BEDROCK_MODEL_SERIALIZER=$(perl5bedrockmodelserializerlib_DATA:.pm=.pm.in)

# Plugins
# -------

perl5blmlib_DATA = \
    BLM/Awk.pm \
    BLM/Benchmark.pm \
    BLM/Date.pm \
    BLM/DBHandler.pm \
    BLM/FileIO.pm \
    BLM/Filter.pm \
    BLM/JSON.pm \
    BLM/IndexedTableHandler.pm \
    BLM/Mail.pm \
    BLM/Plugin.pm \
    BLM/Recycle.pm \
    BLM/FTP.pm \
    BLM/SMTP.pm \
    BLM/Session.pm \
    BLM/ShareDir.pm \
    BLM/Source.pm \
    BLM/Stat.pm \
    BLM/Timenow.pm

BLM=$(perl5blmlib_DATA:.pm=.pm.in)

perl5blmstartuplib_DATA = \
    BLM/Startup/BaseSession.pm \
    BLM/Startup/Bedrock.pm \
    BLM/Startup/Config.pm \
    BLM/Startup/Cookie.pm \
    BLM/Startup/Env.pm \
    BLM/Startup/Header.pm \
    BLM/Startup/Input.pm \
    BLM/Startup/MemorySession.pm \
    BLM/Startup/MySQLSession.pm \
    BLM/Startup/PostgreSQLSession.pm \
    BLM/Startup/REST.pm \
    BLM/Startup/Session.pm \
    BLM/Startup/SessionManager.pm \
    BLM/Startup/SQLSession.pm \
    BLM/Startup/UserSession.pm

BLM_STARTUP=$(perl5blmstartuplib_DATA:.pm=.pm.in)

PERL_PM = \
    Bedrock.pm.in \
    bedrock_handler_common.pm.in \
    $(BEDROCK) \
    $(BEDROCK_APPLICATION) \
    $(BEDROCK_APACHE) \
    $(BEDROCK_APACHE_REQUEST) \
    $(BEDROCK_DBI) \
    $(BEDROCK_LOG) \
    $(BEDROCK_HTML) \
    $(BEDROCK_FILTER) \
    $(BEDROCK_MINISERVER) \
    $(BEDROCK_MODEL) \
    $(BEDROCK_MODEL_SERIALIZER) \
    $(BEDROCK_MODEL_RESERVEDWORDS) \
    $(BEDROCK_POD) \
    $(BEDROCK_CACHE) \
    $(BEDROCK_REQUEST) \
    $(BEDROCK_ROLE) \
    $(BEDROCK_SERVICE) \
    $(BEDROCK_TEMPLATE) \
    $(BEDROCK_TEST) \
    $(BEDROCK_TEXT) \
    $(BEDROCK_TEXT_TAGX) \
    $(BEDROCK_TEXT_TAGX_TAG) \
    $(BEDROCK_TEXT_TAGX_TAG_NOBODY) \
    $(BEDROCK_TEXT_TAGX_TAG_WITHBODY) \
    $(BEDROCK_TEXT_TAGX_TAG_WITHBODY_IF) \
    $(BEDROCK_TEXT_TAGX_TAG_WITHBODY_LOOP) \
    $(BEDROCK_TEXT_TAGX_TERM) \
    $(BEDROCK_XML) \
    $(BEDROCK_SERIALIZER) \
    $(BEDROCK_XML_CONTAINER) \
    $(BLM_INDEXEDTABLEHANDLER) \
    $(BLM) \
    $(BLM_STARTUP)

dist_noinst_DATA = \
    $(PERL_PM) $(shell ls $(srcdir)/t/*)

@do_subst_command@

SUFFIXES = .tdy .in .pm .pm.in .pl

%.pm: %.pm.in
	test -d "$$(dirname "$@")" || $(INSTALL) -d "$$(dirname "$@")"
	$(do_subst) $< > $@

TIDY_PM = $(PERL_PM:.pm.in=.pm.in.tdy)

tidy: $(TIDY_PM)

%.in.tdy: %
	test -e $<.in && perltidy -vt=2 -pt=1 -dws -i=2 -lp -ci=0 -cti=1 $<.in || true
	test -e $@ && cp $@ $<.in && touch $@ || true

%.tdy: %
	test -e $< && perltidy -vt=2 -pt=1 -dws -i=2 -lp -ci=0 -cti=1 $< || true
	test -e $@ && cp $@ $< && touch $@ || true

clean-local:
	find . -name '*.pm' -exec rm {} \;
	rm -rf *.tdy

# test all :  TEST=
# test one :  TEST=01-indexedtablehandler
# test group: TEST=indexedtablehandler
#
FAUXMODULES = \
    Bedrock/Test.pm \
    Bedrock/Test/FauxLogger.pm \
    Bedrock/Test/Utils.pm \
    Bedrock/Test/FauxContext.pm \
    Bedrock/Test/FauxHandler.pm

test: $(FAUXMODULES)
	echo "$$TEST"; \
	if test -z "$$TEST"; then \
	  TEST="$(ALL_TESTS)"; \
	else \
	  TEST="t/$$TEST.t"; \
	fi; \
	if test -n "$$GROUP"; then \
	  TEST="t/*-$$GROUP.t"; \
	fi; \
	if test -e /tmp/mysqld/mysqld.sock; then \
	  DBI_SOCKET=/tmp/mysqld/mysqld.sock; \
	  DBI_PASS=$${DBI_PASS:-bedrock}; \
	fi; \
	DBI_USER="$${DBI_USER:-root}"; \
	DBI_SOCKET="$$DBI_SOCKET" DBI_PASS="$$DBI_PASS" DBI_USER="$$DBI_USER" \
	BEDROCK_CONFIG_PATH=$(top_srcdir)/src/main/bedrock/config \
	  $(PROVE) -v -I $(srcdir)/.. -I $(builddir) -I $(builddir)/Bedrock -I $(builddir)/Bedrock/Text $(srcdir)/$$TEST

prove.sh: Bedrock/Test.pm
	echo "BEDROCK_CONFIG_PATH=$(builddir)/../../bedrock/config $(PROVE) -v -I $(srcdir)/.. -I $(builddir) -I $(builddir)/Bedrock -I $(builddir)/Bedrock/Text $(srcdir)/t" > prove.sh
	chmod 755 prove.sh

CLEANFILES = \
    prove.sh

testsdir = $(datadir)/bedrock/tests/lib

ALL_TESTS = \
    t/00-application.t \
    t/00-array.t \
    t/00-autocomplete.t \
    t/00-bedrock-application-plugin.t \
    t/00-bedrock.t \
    t/00-bedrock-xml.t \
    t/00-blm-startup-bedrock.t \
    t/00-blm-startup-config.t \
    t/00-cache.t \
    t/00-cgi.t \
    t/00-config.t \
    t/00-dbhandler.t \
    t/00-dbi-utils.t \
    t/00-encode.t \
    t/00-form.t \
    t/00-handler-common.t \
    t/00-handler.t \
    t/00-handler-utils.t \
    t/00-hash.t \
    t/00-header.t \
    t/00-if.t \
    t/00-indexedtablehandler.t \
    t/00-load-config.t \
    t/00-logger.t \
    t/00-mail.t \
    t/00-maker.t \
    t/00-model-field.t \
    t/00-model.t \
    t/00-object.t \
    t/00-pager.t \
    t/00-regexp.t \
    t/00-request-cgi.t \
    t/00-scalar.t \
    t/00-session.t \
    t/00-table-name.t \
    t/00-tagx-log.t \
    t/00-template.t \
    t/00-upload.t \
    t/01-config.t \
    t/01-csrf.t \
    t/01-dbhandler.t \
    t/01-handler-utils.t \
    t/01-indexedtablehandler.t \
    t/01-locator.t \
    t/01-logger.t \
    t/01-model-field.t \
    t/01-model.t \
    t/01-shared-dbi.t \
    t/01-tagx-log.t \
    t/01-template.t \
    t/02-indexedtablehandler.t \
    t/02-model.t \
    t/02-template.t \
    t/03-dbhandler.t \
    t/03-indexedtablehandler.t \
    t/03-model.t \
    t/04-indexedtablehandler.t \
    t/04-model.t \
    t/05-indexedtablehandler.t \
    t/05-model.t \
    t/06-indexedtablehandler.t \
    t/06-model.t \
    t/07-indexedtablehandler.t \
    t/07-model.t \
    t/08-indexedtablehandler.t \
    t/08-model.t \
    t/09-model.t

dist_tests_DATA = $(ALL_TESTS)
