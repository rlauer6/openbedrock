#-*- mode:makefile; -*-
SUBDIRS = .

PROJECT_ROOT=$(builddir)

@do_subst_command@

all:

BEDROCK_TESTS = \
    00-var.yml \
    01-multi-line.yml \
    02-null.yml \
    03-if.yml \
    04-foreach.yml \
    05-iif.yml \
    06-open.yml \
    07-plugin.yml \
    08-reftype.yml \
    09-sink.yml \
    10-try.yml \
    11-snippet.yml \
    14-flush.yml \
    15-include.yml \
    16-case.yml \
    17-array.yml \
    18-hash.yml \
    19-pebble.yml \
    20-benchmark.yml \
    22-include.yml

ALL_TESTS = \
    $(BEDROCK_TESTS)

SHELL_MODULES = \
    Bedrock/Apache/Request/Shell.pm \
    Bedrock/Context.pm \
    Bedrock/Request.pm \
    Bedorck/Request/Upload.pm \
    Bedrock/Handler.pm \
    Bedrock/Apache/Bedrock.pm \
    Bedrock/Apache/Constants.pm \
    Bedrock/VERSION.pm

PACKAGE_MODULES = \
    Bedrock/Array.pm \
    Bedrock/Core.pm \
    Bedrock/Cache.pm \
    Bedrock/Cache/Redis.pm \
    Bedrock/Cache/Engine.pm \
    Bedrock/Cache/Memory.pm \
    Bedrock/Cache/Null.pm \
    Bedrock/Cache/Shareable.pm \
    Bedrock/BedrockConfig.pm \
    Bedrock/BedrockCGI.pm \
    Bedrock/BedrockJSON.pm \
    Bedrock/BufferStream.pm \
    Bedrock/Constants.pm \
    Bedrock/DBI/Utils.pm \
    Bedrock/DBI/Locator.pm \
    Bedrock/Dump.pm \
    Bedrock/Dumper.pm \
    Bedrock/Error.pm \
    Bedrock/Exception.pm \
    Bedrock/Handle.pm \
    Bedrock/Hash.pm \
    Bedrock/HTML/Helper.pm \
    Bedrock/LoadConfig.pm \
    Bedrock/Log.pm \
    Bedrock/Logger.pm \
    Bedrock/Model.pm \
    Bedrock/Model/Serializer/MySQL.pm \
    Bedrock/Model/ReservedWords/MySQL.pm \
    Bedrock/Model/Importer.pm \
    Bedrock/Model/Migration.pm \
    Bedrock/Model/Field.pm \
    Bedrock/Model/Maker.pm \
    Bedrock/Model/ReservedWords.pm \
    Bedrock/Model/Handler.pm \
    Bedrock/Model/Role.pm \
    Bedrock/Object.pm \
    Bedrock/Pager.pm \
    Bedrock/Plugin.pm \
    Bedrock/RegExp.pm \
    Bedrock/Request.pm \
    Bedrock/Request/Upload.pm \
    Bedrock/Role/Config.pm \
    Bedrock/Role/DocFinder.pm \
    Bedrock/Router.pm \
    Bedrock/Serializer.pm \
    Bedrock/Service.pm \
    Bedrock/Service/Docs.pm \
    Bedrock/Serializer/BedrockXML.pm \
    Bedrock/Serializer/JSON.pm \
    Bedrock/Serializer/YAML.pm \
    Bedrock/Serializer/XML.pm \
    Bedrock/Snippet.pm \
    Bedrock/Template.pm \
    Bedrock/Template/Email.pm \
    Bedrock/Test.pm \
    Bedrock/Test/Utils.pm \
    Bedrock/Text/URLEncode.pm \
    Bedrock/Text/TagX.pm \
    Bedrock/Text/TagX/Error.pm \
    Bedrock/Text/TagX/Expr.pm \
    Bedrock/Text/TagX/Func.pm \
    Bedrock/Text/TagX/Output.pm \
    Bedrock/Text/TagX/Parser.pm \
    Bedrock/Text/TagX/Scalar.pm \
    Bedrock/Text/TagX/Symtab.pm \
    Bedrock/Text/TagX/TAG.pm \
    Bedrock/Text/TagX/TAG/NoBody.pm \
    Bedrock/Text/TagX/TAG/NoBody/Array.pm \
    Bedrock/Text/TagX/TAG/NoBody/Case.pm \
    Bedrock/Text/TagX/TAG/NoBody/Comment.pm \
    Bedrock/Text/TagX/TAG/NoBody/Exec.pm \
    Bedrock/Text/TagX/TAG/NoBody/Flush.pm \
    Bedrock/Text/TagX/TAG/NoBody/Hash.pm \
    Bedrock/Text/TagX/TAG/NoBody/Iif.pm \
    Bedrock/Text/TagX/TAG/NoBody/Include.pm \
    Bedrock/Text/TagX/TAG/NoBody/NULL.pm \
    Bedrock/Text/TagX/TAG/NoBody/Open.pm \
    Bedrock/Text/TagX/TAG/NoBody/Pebble.pm \
    Bedrock/Text/TagX/TAG/NoBody/Plugin.pm \
    Bedrock/Text/TagX/TAG/NoBody/Raise.pm \
    Bedrock/Text/TagX/TAG/NoBody/RecordSet.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQL.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQLCommit.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQLConnect.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQLRollback.pm \
    Bedrock/Text/TagX/TAG/NoBody/SQLTable.pm \
    Bedrock/Text/TagX/TAG/NoBody/Trace.pm \
    Bedrock/Text/TagX/TAG/NoBody/Var.pm \
    Bedrock/Text/TagX/TAG/SQLConnector.pm \
    Bedrock/Text/TagX/TAG/SQLHandler.pm \
    Bedrock/Text/TagX/TAG/WithBody.pm \
    Bedrock/Text/TagX/TAG/WithBody/Cache.pm \
    Bedrock/Text/TagX/TAG/WithBody/Container.pm \
    Bedrock/Text/TagX/TAG/WithBody/Catch.pm \
    Bedrock/Text/TagX/TAG/WithBody/If.pm \
    Bedrock/Text/TagX/TAG/WithBody/If/Else.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop/Foreach.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop/SQLSelect.pm \
    Bedrock/Text/TagX/TAG/WithBody/Loop/While.pm \
    Bedrock/Text/TagX/TAG/WithBody/NoExec.pm \
    Bedrock/Text/TagX/TAG/WithBody/PebbleDef.pm \
    Bedrock/Text/TagX/TAG/WithBody/Sink.pm \
    Bedrock/Text/TagX/TAG/WithBody/Snippet.pm \
    Bedrock/Text/TagX/TAG/WithBody/Try.pm \
    Bedrock/Text/TagX/TAG/WithBody/Unless.pm \
    Bedrock/Text/TagX/Term.pm \
    Bedrock/Text/TagX/Term/String.pm \
    Bedrock/Text/TagX/Term/Var.pm \
    Bedrock/XML.pm \
    Bedrock/XML/Container.pm \
    Bedrock/XML/Container/Array.pm \
    Bedrock/XML/Container/Object.pm \
    Bedrock/XML/Container/Scalar.pm \
    BLM/DBHandler.pm \
    BLM/Awk.pm \
    BLM/Benchmark.pm \
    BLM/DBHandler.pm \
    BLM/Date.pm \
    BLM/FTP.pm \
    BLM/FileIO.pm \
    BLM/Filter.pm \
    BLM/Filter/crypt.pm \
    BLM/Filter/csv.pm \
    BLM/Filter/xls.pm \
    BLM/JSON.pm \
    BLM/Plugin.pm \
    BLM/Mail.pm \
    BLM/Plugin.pm \
    BLM/Recycle.pm \
    BLM/SMTP.pm \
    BLM/ShareDir.pm \
    BLM/Session.pm \
    BLM/Source.pm \
    BLM/Stat.pm \
    BLM/Timenow.pm \
    BLM/Startup/Header.pm \
    BLM/Startup/Input.pm \
    BLM/Startup/Config.pm \
    BLM/Startup/Env.pm \
    BLM/Startup/Bedrock.pm \
    BLM/IndexedTableHandler.pm \
    BLM/IndexedTableHandler/Common.pm \
    BLM/IndexedTableHandler/RecordSet.pm

PACKAGE_EXE = \
    bin/bedrock.pl \
    bin/bedrock

include $(srcdir)/bedrock-core.mk

dist_noinst_DATA = \
    buildspec.yml \
    requires \
    test-requires \
    bedrock-core.mk \
    postamble
