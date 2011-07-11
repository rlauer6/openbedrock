## Process this file with automake to produce Makefile.in   -*-Makefile-*-

perl5libdir = @PERL_LIBDIR@

perl5bedrocklibdir             		  = $(perl5libdir)/Bedrock
perl5bedrockhtmllibdir             	  = $(perl5libdir)/Bedrock/HTML
perl5bedrockinputsourcelibdir          	  = $(perl5libdir)/Bedrock/InputSource
perl5bedrockapachelibdir       		  = $(perl5libdir)/Bedrock/Apache
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
perl5bedrockxmlcontainerlibdir 		  = $(perl5libdir)/Bedrock/XML/Container

perl5blmlibdir                = $(perl5libdir)/BLM
perl5blmindexedtablehandlerlibdir = $(perl5libdir)/BLM/IndexedTableHandler
perl5blmstartuplibdir 	      = $(perl5libdir)/BLM/Startup
perl5blmstartupsessionlibdir  = $(perl5libdir)/BLM/Startup/Session


dist_perl5lib_DATA = Bedrock.pm

dist_perl5bedrocklib_DATA = \
    Bedrock/Context.pm \
    Bedrock/CGI.pm \
    Bedrock/VERSION.pm \
    Bedrock/XML.pm \
    Bedrock/Array.pm \
    Bedrock/BufferStream.pm \
    Bedrock/BedrockConfig.pm \
    Bedrock/Dump.pm \
    Bedrock/Handle.pm \
    Bedrock/Hash.pm \
    Bedrock/InputSource.pm \
    Bedrock/JSON.pm \
    Bedrock/JSON_PP_Ix.pm \
    Bedrock/Log.pm

dist_perl5bedrockapachelib_DATA = \
    Bedrock/Apache/Bedrock.pm \
    Bedrock/Apache/bedrock.pl \
    Bedrock/Apache/bedrock_sh.pl \
    Bedrock/Apache/Request_cgi.pm \
    Bedrock/Apache/Request_shell.pm

dist_perl5bedrockcontextlib_DATA = \
    Bedrock/Context/Shell.pm


dist_perl5bedrockhtmllib_DATA = \
    Bedrock/HTML/Helper.pm

dist_perl5bedrockinputsourcelib_DATA = \
    Bedrock/InputSource/Term.pm

dist_perl5bedrocktextlib_DATA = \
    Bedrock/Text/TagX.pm \
    Bedrock/Text/URLEncode.pm

dist_perl5bedrocktexttagxlib_DATA = \
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

dist_perl5bedrocktexttagxtaglib_DATA = \
    Bedrock/Text/TagX/TAG/NoBody.pm \
    Bedrock/Text/TagX/TAG/WithBody.pm

dist_perl5bedrocktexttagxtagnobodylib_DATA = \
    Bedrock/Text/TagX/TAG/NoBody/Array.pm \
    Bedrock/Text/TagX/TAG/NoBody/Plugin.pm \
    Bedrock/Text/TagX/TAG/NoBody/Case.pm \
    Bedrock/Text/TagX/TAG/NoBody/Exec.pm \
    Bedrock/Text/TagX/TAG/NoBody/Hash.pm \
    Bedrock/Text/TagX/TAG/NoBody/Include.pm \
    Bedrock/Text/TagX/TAG/NoBody/NULL.pm \
    Bedrock/Text/TagX/TAG/NoBody/Open.pm \
    Bedrock/Text/TagX/TAG/NoBody/Pebble.pm \
    Bedrock/Text/TagX/TAG/NoBody/Raise.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQL.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQLConnect.pm \
    Bedrock/Text/TagX/TAG/NoBody/Trace.pm \
    Bedrock/Text/TagX/TAG/NoBody/Var.pm

dist_perl5bedrocktexttagxtagwithbodylib_DATA = \
    Bedrock/Text/TagX/TAG/WithBody/Cache.pm \
    Bedrock/Text/TagX/TAG/WithBody/Catch.pm \
    Bedrock/Text/TagX/TAG/WithBody/If.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop.pm \
    Bedrock/Text/TagX/TAG/WithBody/Sink.pm \
    Bedrock/Text/TagX/TAG/WithBody/Snippet.pm \
    Bedrock/Text/TagX/TAG/WithBody/Try.pm

dist_perl5bedrocktexttagxtagwithbodyiflib_DATA = \
    Bedrock/Text/TagX/TAG/WithBody/If/Else.pm

dist_perl5bedrocktexttagxtagwithbodylooplib_DATA = \
    Bedrock/Text/TagX/TAG/WithBody/Loop/Foreach.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop/SQLSelect.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop/While.pm

dist_perl5bedrocktexttagxtermlib_DATA = \
    Bedrock/Text/TagX/Term/String.pm \
    Bedrock/Text/TagX/Term/Var.pm

dist_perl5bedrockxmllib_DATA = \
    Bedrock/XML/Container.pm

dist_perl5bedrockxmlcontainerlib_DATA = \
    Bedrock/XML/Container/Array.pm \
    Bedrock/XML/Container/Object.pm \
    Bedrock/XML/Container/Scalar.pm

# Plugins
# -------

dist_perl5blmindexedtablehandlerlib_DATA = \
    BLM/IndexedTableHandler/RecordSet.pm \
    BLM/IndexedTableHandler/Common.pm

dist_perl5blmlib_DATA = \
    BLM/Awk.pm \
    BLM/Benchmark.pm \
    BLM/Date.pm \
    BLM/DBHandler.pm \
    BLM/File.pm \
    BLM/Filter.pm \
    BLM/FileIO.pm \
    BLM/Fortune.pm \
    BLM/Include.pm \
    BLM/IndexedTableHandler.pm \
    BLM/Mail.pm \
    BLM/Number.pm \
    BLM/OrderedObject.pm \
    BLM/Perldoc.pm \
    BLM/PLUGIN.pm \
    BLM/Recycle.pm \
    BLM/Series.pm \
    BLM/FTP.pm \
    BLM/SMTP.pm \
    BLM/Stat.pm \
    BLM/Timenow.pm \
    BLM/SiteFactory.pm \
    BLM/AppPLUGIN.pm \
    BLM/XML.pm

dist_perl5blmstartuplib_DATA = \
    BLM/Startup/Bedrock.pm \
    BLM/Startup/Config.pm \
    BLM/Startup/Cookie.pm \
    BLM/Startup/Env.pm \
    BLM/Startup/Forum.pm \
    BLM/Startup/Header.pm \
    BLM/Startup/Hitcounter.pm \
    BLM/Startup/Input.pm \
    BLM/Startup/MySQLSession.pm \
    BLM/Startup/SQLiteSession.pm \
    BLM/Startup/PostgreSQLSession.pm \
    BLM/Startup/Output.pm \
    BLM/Startup/Session.pm \
    BLM/Startup/SessionManager.pm \
    BLM/Startup/SQLSession.pm \
    BLM/Startup/UserSession.pm \
    BLM/Startup/Tiles.pm

dist_perl5blmstartupsessionlib_DATA = \
    BLM/Startup/Session/GDBM.pm \
    BLM/Startup/Session/SDBM.pm

dist_noinst_DATA = \
    Bedrock/VERSION.pm.in \
    Bedrock/Apache/Request_shell.pm.in

@do_subst_command@

Bedrock/VERSION.pm: % : %.in
	$(do_subst) $< > $@

Bedrock/Apache/Request_shell.pm: % : %.in
	$(do_subst) $< > $@

CLEANFILES = Bedrock/VERSION.pm Bedrock/Apache/Request_shell.pm
