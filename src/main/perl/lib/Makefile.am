## Process this file with automake to produce Makefile.in   -*-Makefile-*-

perl5libdir = @PERL_LIBDIR@

perl5bedrocklibdir             		  = $(perl5libdir)/Bedrock
perl5bedrockapachelibdir       		  = $(perl5libdir)/Bedrock/Apache
perl5bedrockcontextlibdir      		  = $(perl5libdir)/Bedrock/Context
perl5bedrockpdflibdir          		  = $(perl5libdir)/Bedrock/PDF
perl5bedrocksislibdir          		  = $(perl5libdir)/Bedrock/SIS
perl5bedrocksisinputsourcelibdir          = $(perl5libdir)/Bedrock/SIS/InputSource
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
perl5blmpdflibdir             = $(perl5libdir)/BLM/PDF
perl5blmpdfafmlibdir          = $(perl5libdir)/BLM/PDF/afm
perl5blmpdfdocumentlibdir     = $(perl5libdir)/BLM/PDF/Document
perl5blmpdfdocumentpagelibdir = $(perl5libdir)/BLM/PDF/Document/Page
perl5blmpdfrenderlibdir       = $(perl5libdir)/BLM/PDF/Render
perl5blmpdfrenderobjectlibdir = $(perl5libdir)/BLM/PDF/Render/Object
perl5blmpdfrendertextlibdir   = $(perl5libdir)/BLM/PDF/Render/Text
perl5blmpdftextlibdir         = $(perl5libdir)/BLM/PDF/Text
perl5blmpdftexteffectslibdir  = $(perl5libdir)/BLM/PDF/Text/Effects
perl5blmstartuplibdir 	      = $(perl5libdir)/BLM/Startup
perl5blmstartupsessionlibdir  = $(perl5libdir)/BLM/Startup/Session


dist_perl5lib_DATA = Bedrock.pm

dist_perl5bedrocklib_DATA = \
    Bedrock/Context.pm \
    Bedrock/VERSION.pm \
    Bedrock/XML.pm

dist_perl5bedrockapachelib_DATA = \
    Bedrock/Apache/Bedrock.pm \
    Bedrock/Apache/bedrock.pl \
    Bedrock/Apache/bedrock_sh.pl \
    Bedrock/Apache/PDFrock.pm \
    Bedrock/Apache/pdfrock.pl \
    Bedrock/Apache/Request_cgi.pm \
    Bedrock/Apache/Request_shell.pm

dist_perl5bedrockcontextlib_DATA = \
    Bedrock/Context/Shell.pm

dist_perl5bedrockpdflib_DATA = \
    Bedrock/PDF/Handle.pm \
    Bedrock/PDF/Maker.pm

dist_perl5bedrocksislib_DATA = \
    Bedrock/SIS/Array.pm \
    Bedrock/SIS/BufferStream.pm \
    Bedrock/SIS/Config.pm \
    Bedrock/SIS/Dump.pm \
    Bedrock/SIS/Handle.pm \
    Bedrock/SIS/Hash.pm \
    Bedrock/SIS/InputSource.pm \
    Bedrock/SIS/Log.pm

dist_perl5bedrocksisinputsourcelib_DATA = \
    Bedrock/SIS/InputSource/Term.pm

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
    Bedrock/Text/TagX/TAG/NoBody/Exec.pm \
    Bedrock/Text/TagX/TAG/NoBody/Include.pm \
    Bedrock/Text/TagX/TAG/NoBody/NULL.pm \
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


# BLM modules
# -----------

dist_perl5blmlib_DATA = \
    BLM/Array.pm \
    BLM/Awk.pm \
    BLM/Benchmark.pm \
    BLM/Date.pm \
    BLM/File.pm \
    BLM/FileIO.pm \
    BLM/Fortune.pm \
    BLM/Include.pm \
    BLM/Keys.pm \
    BLM/Mail.pm \
    BLM/Number.pm \
    BLM/OrderedObject.pm \
    BLM/Perldoc.pm \
    BLM/Recycle.pm \
    BLM/Series.pm \
    BLM/SIMPLEFTP.pm \
    BLM/SMTP.pm \
    BLM/Stat.pm \
    BLM/String.pm \
    BLM/Timenow.pm

dist_perl5blmstartuplib_DATA = \
    BLM/Startup/AutoDB.pm \
    BLM/Startup/Bedrock.pm \
    BLM/Startup/Config.pm \
    BLM/Startup/Cookie.pm \
    BLM/Startup/Env.pm \
    BLM/Startup/Forum.pm \
    BLM/Startup/Header.pm \
    BLM/Startup/Hitcounter.pm \
    BLM/Startup/Input.pm \
    BLM/Startup/Output.pm \
    BLM/Startup/Session.pm \
    BLM/Startup/UserSession.pm

dist_perl5blmstartupsessionlib_DATA = \
    BLM/Startup/Session/GDBM.pm \
    BLM/Startup/Session/SDBM.pm

dist_perl5blmpdflib_DATA = \
    BLM/PDF/Constants.pm \
    BLM/PDF/Log.pm \
    BLM/PDF/PDF.pm

dist_perl5blmpdfafmlib_DATA = \
    BLM/PDF/afm/cob_____.afm \
    BLM/PDF/afm/cobo____.afm \
    BLM/PDF/afm/com_____.afm \
    BLM/PDF/afm/coo_____.afm \
    BLM/PDF/afm/hv______.afm \
    BLM/PDF/afm/hvb_____.afm \
    BLM/PDF/afm/hvbo____.afm \
    BLM/PDF/afm/hvo_____.afm \
    BLM/PDF/afm/sy______.afm \
    BLM/PDF/afm/tib_____.afm \
    BLM/PDF/afm/tibi____.afm \
    BLM/PDF/afm/tii_____.afm \
    BLM/PDF/afm/tir_____.afm \
    BLM/PDF/afm/zd______.afm

dist_perl5blmpdfdocumentlib_DATA = \
    BLM/PDF/Document/Document.pm \
    BLM/PDF/Document/Page.pm

dist_perl5blmpdfdocumentpagelib_DATA = \
    BLM/PDF/Document/Page/Properties.pm

dist_perl5blmpdfrenderlib_DATA = \
    BLM/PDF/Render/Array.pm \
    BLM/PDF/Render/Catalog.pm \
    BLM/PDF/Render/Cursor.pm \
    BLM/PDF/Render/Dictionary.pm \
    BLM/PDF/Render/Document.pm \
    BLM/PDF/Render/Newline.pm \
    BLM/PDF/Render/Outline.pm \
    BLM/PDF/Render/Page.pm \
    BLM/PDF/Render/Pages.pm \
    BLM/PDF/Render/PDFObject.pm \
    BLM/PDF/Render/Stream.pm \
    BLM/PDF/Render/Text.pm

dist_perl5blmpdfrenderobjectlib_DATA = \
    BLM/PDF/Render/Object/Registry.pm

dist_perl5blmpdfrendertextlib_DATA = \
    BLM/PDF/Render/Text/Metrics.pm \
    BLM/PDF/Render/Text/Object.pm

dist_perl5blmpdftextlib_DATA = \
    BLM/PDF/Text/Font.pm \
    BLM/PDF/Text/Properties.pm \
    BLM/PDF/Text/Text.pm

dist_perl5blmpdftexteffectslib_DATA = \
    BLM/PDF/Text/Effects/Gradient.pm
