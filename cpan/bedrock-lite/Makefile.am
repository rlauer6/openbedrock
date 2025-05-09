#-*- mode:makefile; -*-
SUBDIRS = .

PROJECT_ROOT=$(builddir)

LITE = Lite.pm.in

@do_subst_command@

all:

lib/Bedrock/Lite.pm: $(LITE)
	test -d $(builddir)/lib/Bedrock || mkdir -p $(builddir)/lib/Bedrock
	$(do_subst) $< > $@

SHELL_MODULES = \
    lib/Bedrock/Apache/Request/Shell.pm \
    lib/Bedrock/Context.pm \
    lib/Bedrock/Handler.pm \
    lib/Bedrock/Apache/Bedrock.pm \
    lib/Bedrock/Apache/Constants.pm \
    lib/Bedrock/VERSION.pm

PACKAGE_MODULES = \
    lib/Bedrock.pm \
    lib/Bedrock/Array.pm \
    lib/Bedrock/BedrockConfig.pm \
    lib/Bedrock/BedrockJSON.pm \
    lib/Bedrock/BufferStream.pm \
    lib/Bedrock/Constants.pm \
    lib/Bedrock/DBI/Utils.pm \
    lib/Bedrock/Dump.pm \
    lib/Bedrock/Dumper.pm \
    lib/Bedrock/Hash.pm \
    lib/Bedrock/HTML/Helper.pm \
    lib/Bedrock/LoadConfig.pm \
    lib/Bedrock/Log.pm \
    lib/Bedrock/Logger.pm \
    lib/Bedrock/Model/Role.pm \
    lib/Bedrock/Model/Field.pm \
    lib/Bedrock/Model/Handler.pm \
    lib/Bedrock/Object.pm \
    lib/Bedrock/Plugin.pm \
    lib/Bedrock/RegExp.pm \
    lib/Bedrock/Role/Config.pm \
    lib/Bedrock/Serializer.pm \
    lib/Bedrock/Snippet.pm \
    lib/Bedrock/Template.pm \
    lib/Bedrock/Template/Email.pm \
    lib/Bedrock/Text/URLEncode.pm \
    lib/Bedrock/Text/TagX.pm \
    lib/Bedrock/Text/TagX/Error.pm \
    lib/Bedrock/Text/TagX/Expr.pm \
    lib/Bedrock/Text/TagX/Func.pm \
    lib/Bedrock/Text/TagX/Output.pm \
    lib/Bedrock/Text/TagX/Parser.pm \
    lib/Bedrock/Text/TagX/Scalar.pm \
    lib/Bedrock/Text/TagX/Symtab.pm \
    lib/Bedrock/Text/TagX/TAG.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Array.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Case.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Comment.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Exec.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Flush.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Hash.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Iif.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Include.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/NULL.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Open.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Pebble.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Plugin.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Raise.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/RecordSet.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/SQL.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/SQLCommit.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/SQLConnect.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/SQLRollback.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/SQLTable.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Trace.pm \
    lib/Bedrock/Text/TagX/TAG/NoBody/Var.pm \
    lib/Bedrock/Text/TagX/TAG/SQLConnector.pm \
    lib/Bedrock/Text/TagX/TAG/SQLHandler.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Cache.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Catch.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/If.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/If/Else.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Loop.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Loop/Foreach.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Loop/SQLSelect.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Loop/While.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/NoExec.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/PebbleDef.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Sink.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Snippet.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Try.pm \
    lib/Bedrock/Text/TagX/TAG/WithBody/Unless.pm \
    lib/Bedrock/Text/TagX/Term.pm \
    lib/Bedrock/Text/TagX/Term/String.pm \
    lib/Bedrock/Text/TagX/Term/Var.pm \
    lib/Bedrock/XML.pm \
    lib/Bedrock/XML/Container.pm \
    lib/Bedrock/XML/Container/Array.pm \
    lib/Bedrock/XML/Container/Object.pm \
    lib/Bedrock/XML/Container/Scalar.pm \
    lib/BLM/DBHandler.pm \
    lib/BLM/Startup/Header.pm \
    lib/BLM/Startup/Input.pm \
    lib/BLM/Startup/Config.pm \
    lib/BLM/Startup/Env.pm \
    lib/BLM/Startup/Bedrock.pm \
    lib/BLM/IndexedTableHandler.pm \
    lib/BLM/IndexedTableHandler/Common.pm \
    lib/BLM/IndexedTableHandler/RecordSet.pm

PACKAGE_EXE = \
    bin/bedrock.pl

include $(srcdir)/bedrock-lite.mk

dist_noinst_DATA = \
    buildspec.yml \
    Lite.pm.in \
    00-bedrock.t.in \
    requires.in \
    test-requires.in \
    bedrock-lite.mk

CLEANFILES += \
    $(PACKAGE_MODULES) \
    $(SHELL_MODULES) \
    $(PACKAGE_EXE) \
    Lite.pm \
    $(builddir)/lib/Bedrock/Lite.pm
