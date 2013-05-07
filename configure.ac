dnl Process this file with autoconf to produce a configure script. -*-Autoconf-*-

dnl +-------------------------+
dnl |  Autotools Boilerplate  |
dnl +-------------------------+

AC_INIT([bedrock], [2.3.3], [rlauer6@comcast.net])

dnl Ensure that a recent-enough version of Autoconf is being used
AC_PREREQ([2.61])

AC_CONFIG_AUX_DIR([autotools])

dnl Indicate dir where our custom m4 macros may be found (future
dnl proofing; as of may not be used yet...)
AC_CONFIG_MACRO_DIR([autotools])

dnl Turn on all Automake warnings and report them as errors
AM_INIT_AUTOMAKE([-Wall -Werror foreign])


dnl AC_REVISION puts cvs revision in comment at top of generated 'configure'
AC_REVISION([$Revision$])dnl

DFLT_MAINTAINER="rlauer@signatureinfo.com"
AC_SUBST([DFLT_MAINTAINER])

if ! test -e bedrock-build; then
 BEDROCK_RELEASE="0"
else
  BEDROCK_RELEASE=$(cat bedrock-build)
fi

AC_SUBST([BEDROCK_RELEASE])

dnl +------------------------+
dnl |  Checks for programs.  |
dnl +------------------------+

dnl makes $(LN_S) available in our Makefile.am files
AC_PROG_LN_S

AC_PATH_PROG(BASH_SH, bash)
if test -z "$BASH_SH"; then
    AC_MSG_ERROR([bash not found])
fi

AC_PATH_PROG([CAT], [cat])
if test -z "$CAT"; then
    AC_MSG_ERROR([cat not found])
fi

AC_PATH_PROG([CHGRP], [chgrp])
if test -z "$CHGRP"; then
    AC_MSG_ERROR([chgrp not found])
fi

AC_PATH_PROG([CHOWN], [chown])
if test -z "$CHOWN"; then
    AC_MSG_ERROR([chown not found])
fi

AC_PATH_PROG([FIND], [find])
if test -z "$FIND"; then
    AC_MSG_ERROR([find not found]);dnl Ha!
fi

AC_PATH_PROG([AWK], [awk])
if test -z "$AWK"; then
    AC_MSG_ERROR([awk not found]);dnl Ha!
fi

AC_PATH_PROG([GREP], [grep])
if test -z "$GREP"; then
    AC_MSG_ERROR([grep not found])
fi

AC_PATH_PROG([SED], [sed])
if test -z "$SED"; then
    AC_MSG_ERROR([sed not found])
fi

AC_PATH_PROG([RM], [rm])
if test -z "$RM"; then
    AC_MSG_ERROR([rm not found])
fi

AC_PATH_PROG([RMDIR], [rmdir])
if test -z "$RMDIR"; then
    AC_MSG_ERROR([rmdir not found])
fi

dnl ...for Debian layouts, we use a2ensite to enable a virtual host
AC_PATH_PROG([A2ENSITE],
        [a2ensite])

apache_layout=Debian
AC_ARG_WITH(
        [apache-layout],[  --with-apache-layout=LAYOUT      apache layout style (Debian or RedHat), default=Debian],
        [
         case "$withval" in

           'Debian')
                     apache_layout="$withval"
                     if test -z "$A2ENSITE"; then
                       AC_ERROR([Debian layout doubtful, no a2ensite?])
                     fi
                     ;;
          'RedHat')
                     apache_layout="$withval"
                     ;;
                 *)
                    if test "$withval"; then
                      AC_ERROR([only values Debian or RedHat allowed])
                    fi
                    ;;
         esac
        ]
        )

AC_SUBST([apache_layout])

apache_default_htdocsdir=/var/www
if test "$apache_layout" = "RedHat"; then
  apache_default_htdocsdir=/var/www/html
fi

AC_SUBST([apache_default_htdocsdir])

dnl require /at least/ perl version 5.8.0
ads_PROG_PERL([5.008000])

# pod2man comes with perl, which the above verifies that we have. Not yet sure
# if we can rely on that (distribution packaging may provide it in an optional
# package, for instance), so we check for it explicitly here. We use pod2man
# at build time to create some of our man pages.
AC_PATH_PROG([POD2MAN], [pod2man])
if test -z "$POD2MAN"; then
    AC_MSG_ERROR([pod2man program not found])
fi


dnl +------------------------+
dnl |  Checks for Libraries  |
dnl +------------------------+


dnl Perl Libs (3rd party)
dnl ---------------------
dnl Note that we test for some modules which are currently distributed along
dnl with the Perl 5.8.8 core. This is done because I'm too lazy to track down
dnl specifically /which/ version of Perl started shipping with each specific
dnl module. These tests are cheap, so this should be a non-issue; it's
dnl infinitely better than discovering an oversite at runtime.
dnl
# Required Perl modules
ads_PERL_MODULE([Apache2::Const], [REQUIRED])
ads_PERL_MODULE([AppConfig], [REQUIRED])
ads_PERL_MODULE([Carp], [REQUIRED])
ads_PERL_MODULE([Crypt::CBC])
ads_PERL_MODULE([Crypt::DES])
ads_PERL_MODULE([CGI], [REQUIRED], [3.15])
ads_PERL_MODULE([Cwd],  [REQUIRED])
ads_PERL_MODULE([DBI], [REQUIRED], [1.13])
ads_PERL_MODULE([Date::Calc], [REQUIRED], [4.3])
ads_PERL_MODULE([Digest::SHA],[REQUIRED])
ads_PERL_MODULE([Fcntl],  [REQUIRED])
ads_PERL_MODULE([File::Basename],  [REQUIRED])
ads_PERL_MODULE([File::Copy],  [REQUIRED])
ads_PERL_MODULE([File::Path],  [REQUIRED])
ads_PERL_MODULE([File::Temp],  [REQUIRED])
ads_PERL_MODULE([File::Spec::Functions],  [REQUIRED])
ads_PERL_MODULE([Getopt::Long], [REQUIRED])
ads_PERL_MODULE([GDBM_File], [REQUIRED], [1.03])
ads_PERL_MODULE([IO::File], [REQUIRED])
ads_PERL_MODULE([IO::Handle], [REQUIRED])
#
# IO::Scalar is from the IO-stringy package, available here:
#     http://www.cpan.org/modules/by-module/IO/
ads_PERL_MODULE([IO::Scalar], [REQUIRED])
ads_PERL_MODULE([IPC::Shareable], [REQUIRED])
ads_PERL_MODULE([Time::HiRes], [REQUIRED])
#
ads_PERL_MODULE([JSON], [REQUIRED])
ads_PERL_MODULE([MIME::Base64], [REQUIRED])
ads_PERL_MODULE([Net::FTP], [REQUIRED], [2.56])
ads_PERL_MODULE([Net::SMTP], [REQUIRED], [2.15])
ads_PERL_MODULE([Spreadsheet::ParseExcel],[OPTIONAL])
ads_PERL_MODULE([Text::CSV_XS],[OPTIONAL])
ads_PERL_MODULE([Tie::IxHash], [REQUIRED])
ads_PERL_MODULE([XML::Simple], [REQUIRED])
ads_PERL_MODULE([XML::Parser], [REQUIRED])

# Optional Perl modules
ads_PERL_MODULE([Hash::Util],  [OPTIONAL])

dnl +---------------------+
dnl |  Autotools Output.  |
dnl +---------------------+
ads_PERL_LIBDIR

pkglibdir=${libdir}/${PACKAGE}
AC_SUBST([pkglibdir])

cgibindir=${pkglibdir}/cgi-bin
AC_SUBST([cgibindir], ["\${pkglibdir}/cgi-bin"])

htdocsdir=${datadir}/${PACKAGE}/htdocs
AC_SUBST([htdocsdir], ["\${datadir}/\${PACKAGE}/htdocs"])

pebblesdir=${datadir}/${PACKAGE}/pebbles
AC_SUBST([pebblesdir], ["\${datadir}/\${PACKAGE}/pebbles"])

imgdir=${datadir}/${PACKAGE}/img
AC_SUBST([imgdir], ["\${datadir}/\${PACKAGE}/img"])

cssdir=${datadir}/${PACKAGE}/css
AC_SUBST([cssdir], ["\${datadir}/\${PACKAGE}/css"])

configdir=${libdir}/${PACKAGE}/config
AC_SUBST([configdir], ["\${libdir}/\${PACKAGE}/config"])


# FIXME: These are not general, so won't be correct in all
#        circumstances. They'll work correctly once we have full Perl
#        support.
AC_SUBST([perl5_pkgdatadir], ["\${datadir}/${PACKAGE}/perl5"])
AC_SUBST([perl5_pkglibdir],  ["\${libdir}/${PACKAGE}/perl5"])
AC_SUBST([perl5_pkgvdatadir], ["\${datadir}/${PACKAGE}-${VERSION}/perl5"])
AC_SUBST([perl5_pkgvlibdir],  ["\${libdir}/${PACKAGE}-${VERSION}/perl5"])

AX_DISTCHECK_HACK

## The 'do_subst' Makefile var is the conventional name for manual
## filtering process that needs to be done at build time.
##
## Basically, any file we generate that is not a Makefile should be
## filtered at build time rather than at configure time; at build
## time, autotools variables will be fully expanded (well, expanded
## recursively, which amounts to the same thing) and allows any of the
## make vars to be overridden on the 'make' command line. This also
## avoids other kludgey hacks, such as eval'ing shell variables to
## expand them at configure time).
##
## Note that we replace all of the autoconf installation directory
## vars (see "Installation Directory Variables" in the autoconf
## manual) and most of the autoconf preset output variables (see
## "Preset Output Variables" in the autoconf manual). The exceptions
## to that latter are flag vars to the C/C++/Fortran compilers,
## linkers, etc. (CFLAGS and friends), and the 'configure_input' var,
## which we have to provide our own variation of. We also omit
## 'builddir' (which is always '.'); in this last case, what you
## probably want instead is 'abs_builddir', which we provide.
[
do_subst_command='do_subst = sed \
  -e '"'"'s,[@]PACKAGE[@],$(PACKAGE),g'"'"' \
  -e '"'"'s,[@]VERSION[@],$(VERSION),g'"'"' \
  -e '"'"'s,[@]PATH_SEPARATOR[@],$(PATH_SEPARATOR),g'"'"' \
  -e '"'"'s,[@]configure_input[@],Generated from $@.in; do not edit by hand.,g'"'"' \
  -e "s,[@]BUILD_DATE[@],$$(date '"'"'+%Y-%m-%d %H:%M:%S'"'"'),g" \
  \
  -e '"'"'s,[@]bindir[@],$(bindir),g'"'"' \
  -e '"'"'s,[@]datadir[@],$(datadir),g'"'"' \
  -e '"'"'s,[@]exec_prefix[@],$(exec_prefix),g'"'"' \
  -e '"'"'s,[@]includedir[@],$(includedir),g'"'"' \
  -e '"'"'s,[@]infodir[@],$(infodir),g'"'"' \
  -e '"'"'s,[@]libdir[@],$(libdir),g'"'"' \
  -e '"'"'s,[@]libexecdir[@],$(libexecdir),g'"'"' \
  -e '"'"'s,[@]localstatedir[@],$(localstatedir),g'"'"' \
  -e '"'"'s,[@]mandir[@],$(mandir),g'"'"' \
  -e '"'"'s,[@]oldincludedir[@],$(oldincludedir),g'"'"' \
  -e '"'"'s,[@]prefix[@],$(prefix),g'"'"' \
  -e '"'"'s,[@]sbindir[@],$(sbindir),g'"'"' \
  -e '"'"'s,[@]sharedstatedir[@],$(sharedstatedir),g'"'"' \
  -e '"'"'s,[@]sysconfdir[@],$(sysconfdir),g'"'"' \
  \
  -e '"'"'s,[@]abs_builddir[@],$(abs_builddir),g'"'"' \
  -e '"'"'s,[@]abs_srcdir[@],$(abs_srcdir),g'"'"' \
  -e '"'"'s,[@]abs_top_builddir[@],$(abs_top_builddir),g'"'"' \
  -e '"'"'s,[@]srcdir[@],$(srcdir),g'"'"' \
  -e '"'"'s,[@]top_builddir[@],$(top_builddir),g'"'"' \
  -e '"'"'s,[@]top_srcdir[@],$(top_srcdir),g'"'"' \
  \
  -e '"'"'s,[@]cgibindir[@],$(cgibindir),g'"'"' \
  -e '"'"'s,[@]htdocsdir[@],$(htdocsdir),g'"'"' \
  -e '"'"'s,[@]pebblesdir[@],$(pebblesdir),g'"'"' \
  -e '"'"'s,[@]imgdir[@],$(imgdir),g'"'"' \
  -e '"'"'s,[@]cssdir[@],$(cssdir),g'"'"' \
  -e '"'"'s,[@]configdir[@],$(configdir),g'"'"' \
  -e '"'"'s,[@]pkglibdir[@],$(pkglibdir),g'"'"' \
  \
  -e '"'"'s,[@]perlrun[@],$(perlrun),g'"'"' \
  -e '"'"'s,[@]co[@],$(co),g'"'"' \
  -e '"'"'s,[@]ci[@],$(ci),g'"'"' \
  -e '"'"'s,[@]rlog[@],$(rlog),g'"'"' \
\
  -e '"'"'s,[@]PERL[@],$(PERL),g'"'"' \
  -e '"'"'s,[@]PERL_LIBDIR[@],$(PERL_LIBDIR),g'"'"' \
  -e '"'"'s,[@]POD2MAN[@],$(POD2MAN),g'"'"' \
  -e '"'"'s,[@]ax_perl5_extra_includes[@],$(ax_perl5_extra_includes),g'"'"' \
  -e '"'"'s,[@]perl5_pkgdatadir[@],$(perl5_pkgdatadir),g'"'"' \
  -e '"'"'s,[@]perl5_pkgvdatadir[@],$(perl5_pkgvdatadir),g'"'"' \
  -e '"'"'s,[@]perl5_pkglibdir[@],$(perl5_pkglibdir),g'"'"' \
  -e '"'"'s,[@]perl5_pkgvlibdir[@],$(perl5_pkgvlibdir),g'"'"' \
\
  -e '"'"'s,[@]apache_default_htdocsdir[@],$(apache_default_htdocsdir),g'"'"' \
\
  -e '"'"'s,[@]AWK[@],$(AWK),g'"'"' \
  -e '"'"'s,[@]BASH_SH[@],$(BASH_SH),g'"'"' \
  -e '"'"'s,[@]CAT[@],$(CAT),g'"'"' \
  -e '"'"'s,[@]CHGRP[@],$(CHGRP),g'"'"' \
  -e '"'"'s,[@]CHOWN[@],$(CHOWN),g'"'"' \
  -e '"'"'s,[@]CI[@],$(CI),g'"'"' \
  -e '"'"'s,[@]CO[@],$(CO),g'"'"' \
  -e '"'"'s,[@]FIND[@],$(FIND),g'"'"' \
  -e '"'"'s,[@]GREP[@],$(GREP),g'"'"' \
  -e '"'"'s,[@]SED[@],$(SED),g'"'"' \
  -e '"'"'s,[@]RCS[@],$(RCS),g'"'"' \
  -e '"'"'s,[@]RLOG[@],$(RLOG),g'"'"' \
  -e '"'"'s,[@]RM[@],$(RM),g'"'"' \
  -e '"'"'s,[@]RMDIR[@],$(RMDIR),g'"'"' \
'
]
AC_SUBST([do_subst_command])


# Tell our Makefiles where to find our Perl 5 @INC munger snippet. Making
# this a configure-time substitution var allows us to move the file
# someplace else in the source tree or rename it w/o modifying any of our
# Makefile.am files.
bedrock_perl5_inc_begin_block_snippet_filepath="\$(top_builddir)/src/main/resources/bedrock-perl5-inc-begin-block.snippet"
AC_SUBST([bedrock_perl5_inc_begin_block_snippet_filepath])


dnl AC_CONFIG_FILES requires a list of file paths, but we do not want
dnl to have to maintain the list by hand.
dnl
dnl To obtain a list of of paths to all Makefiles we want to have
dnl generated, based on the existence of Makefile.am files, run the
dnl following shell snippet (for use as the argument to
dnl AC_CONFIG_FILES).
dnl
dnl Note that we take care to m4-quote the output strings. Filenames
dnl with square brackets in them will break this, so don't do that.
dnl
dnl   find . -type f -name 'Makefile.am' -printf "%P\n"| sed -e 's/\.am$//g;s/^/[/g;s/$/]/g' | sort
dnl
dnl Cookbook for emacs users:
dnl   1. Delete all [**/Makefile] entries from args to AC_CONFIG_FILES below
dnl
dnl   2. Copy the above 'find' command line (M-w)
dnl
dnl   3. Place point (cursor) on a line by itself after
dnl      AC_CONFIG_FILES's opening paren and set mark (C-SPACE)
dnl
dnl   4. Run the 'find' command, inserting the output at point:
dnl          C-u M-! C-y RET
dnl
dnl   5. Use `indent-region' (C-M-\) to indent the quoted
dnl      strings. Region is already set up because we set the mark above.

dnl Declare our output Makefiles
AC_CONFIG_FILES(
	[${PACKAGE_NAME}.spec]
        [Makefile]
        [bin/Makefile]
        [src/Makefile]
        [src/main/Makefile]
        [src/main/bedrock/Makefile]
        [src/main/bedrock/pebbles/Makefile]
        [src/main/bedrock/img/Makefile]
        [src/main/bedrock/htdocs/Makefile]
        [src/main/bedrock/css/Makefile]
        [src/main/bedrock/config/Makefile]
        [src/main/perl/Makefile]
        [src/main/perl/bin/Makefile]
        [src/main/perl/cgi-bin/Makefile]
        [src/main/perl/lib/Makefile]
        [src/main/resources/Makefile]
)

dnl Actually output the declared files
AC_OUTPUT


# Prints on stdout the fully expanded path represented by the value in
# the SHELL_VAR_NAME param. Does /not/ assign the expanded value to
# the named shell var.
#
# __poor_mans_expand_file_name( SHELL_VAR_NAME )
#
# @param SHELL_VAR_NAME should be set to the /name/ of an existing
#                       shell variable whose value contains a
#                       directory path that may or may not need
#                       expansion of the configure shell variables
#                       ($prefix, and the like).
#
__poor_mans_expand_file_name () {
    _tmp_name=$1
    _tmp_last="`eval echo '${'"${_tmp_name}"'}'`"
    if test -z "${_tmp_last}"; then
        printf "__poor_mans_expand_file_name() (WARNING): var \"%s\" is empty\n" \
          "${_tmp_name}" 1>&2
        return 0;  # nothing to do
    fi
    _tmp_last_expanded="`eval echo ${_tmp_last}`"
    while test "${_tmp_last_expanded}" != "${_tmp_last}"; do

        # Set 'last' hold var to most recently expanded version...
        _tmp_last="${_tmp_last_expanded}"

        # ...and try to expand further.
        _tmp_last_expanded="`eval echo ${_tmp_last_expanded}`"
    done
    printf "%s\n" "${_tmp_last_expanded}"
    unset _tmp_last_expanded
    unset _tmp_last
    unset _tmp_name
    return 0;
}

dnl show user a summary of the configured options
printf "\n"
printf "${PACKAGE} has been configured with the following options:\n"
printf "                        Prefix: %s\n" "`__poor_mans_expand_file_name prefix`"
printf "                 User binaries: %s\n" "`__poor_mans_expand_file_name bindir`"
printf "               System binaries: %s\n" "`__poor_mans_expand_file_name sbindir`"
printf "           Configuration files: %s\n" "`__poor_mans_expand_file_name sysconfdir`"
printf "                  Manual pages: %s\n" "`__poor_mans_expand_file_name mandir`"
printf "\n"
printf "                     pkglibdir: %s\n" "`__poor_mans_expand_file_name pkglibdir`"
printf "                     cgibindir: %s\n" "`__poor_mans_expand_file_name cgibindir`"
printf "                     htdocsdir: %s\n" "`__poor_mans_expand_file_name htdocsdir`"
printf "                    pebblesdir: %s\n" "`__poor_mans_expand_file_name pebblesdir`"
printf "                        imgdir: %s\n" "`__poor_mans_expand_file_name imgdir`"
printf "\n"
printf "                          bash: %s\n" "`__poor_mans_expand_file_name BASH_SH`"
printf "                          perl: %s\n" "`__poor_mans_expand_file_name PERL`"
printf "\n"


## DEBUG: Show all variables set in the shell at the end of 'configure' run
## set | grep -v '^[ {}]' | sort
