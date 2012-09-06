# generated automatically by aclocal 1.11.1 -*- Autoconf -*-

# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004,
# 2005, 2006, 2007, 2008, 2009  Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
m4_if(m4_defn([AC_AUTOCONF_VERSION]), [2.68],,
[m4_warning([this file was generated for autoconf 2.68.
You have another version of autoconf.  It may work, but is not guaranteed to.
If you have problems, you may need to regenerate the build system entirely.
To do so, use the procedure documented by the package, typically `autoreconf'.])])

# Copyright (C) 2002, 2003, 2005, 2006, 2007, 2008  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_AUTOMAKE_VERSION(VERSION)
# ----------------------------
# Automake X.Y traces this macro to ensure aclocal.m4 has been
# generated from the m4 files accompanying Automake X.Y.
# (This private macro should not be called outside this file.)
AC_DEFUN([AM_AUTOMAKE_VERSION],
[am__api_version='1.11'
dnl Some users find AM_AUTOMAKE_VERSION and mistake it for a way to
dnl require some minimum version.  Point them to the right macro.
m4_if([$1], [1.11.1], [],
      [AC_FATAL([Do not call $0, use AM_INIT_AUTOMAKE([$1]).])])dnl
])

# _AM_AUTOCONF_VERSION(VERSION)
# -----------------------------
# aclocal traces this macro to find the Autoconf version.
# This is a private macro too.  Using m4_define simplifies
# the logic in aclocal, which can simply ignore this definition.
m4_define([_AM_AUTOCONF_VERSION], [])

# AM_SET_CURRENT_AUTOMAKE_VERSION
# -------------------------------
# Call AM_AUTOMAKE_VERSION and AM_AUTOMAKE_VERSION so they can be traced.
# This function is AC_REQUIREd by AM_INIT_AUTOMAKE.
AC_DEFUN([AM_SET_CURRENT_AUTOMAKE_VERSION],
[AM_AUTOMAKE_VERSION([1.11.1])dnl
m4_ifndef([AC_AUTOCONF_VERSION],
  [m4_copy([m4_PACKAGE_VERSION], [AC_AUTOCONF_VERSION])])dnl
_AM_AUTOCONF_VERSION(m4_defn([AC_AUTOCONF_VERSION]))])

# AM_AUX_DIR_EXPAND                                         -*- Autoconf -*-

# Copyright (C) 2001, 2003, 2005  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# For projects using AC_CONFIG_AUX_DIR([foo]), Autoconf sets
# $ac_aux_dir to `$srcdir/foo'.  In other projects, it is set to
# `$srcdir', `$srcdir/..', or `$srcdir/../..'.
#
# Of course, Automake must honor this variable whenever it calls a
# tool from the auxiliary directory.  The problem is that $srcdir (and
# therefore $ac_aux_dir as well) can be either absolute or relative,
# depending on how configure is run.  This is pretty annoying, since
# it makes $ac_aux_dir quite unusable in subdirectories: in the top
# source directory, any form will work fine, but in subdirectories a
# relative path needs to be adjusted first.
#
# $ac_aux_dir/missing
#    fails when called from a subdirectory if $ac_aux_dir is relative
# $top_srcdir/$ac_aux_dir/missing
#    fails if $ac_aux_dir is absolute,
#    fails when called from a subdirectory in a VPATH build with
#          a relative $ac_aux_dir
#
# The reason of the latter failure is that $top_srcdir and $ac_aux_dir
# are both prefixed by $srcdir.  In an in-source build this is usually
# harmless because $srcdir is `.', but things will broke when you
# start a VPATH build or use an absolute $srcdir.
#
# So we could use something similar to $top_srcdir/$ac_aux_dir/missing,
# iff we strip the leading $srcdir from $ac_aux_dir.  That would be:
#   am_aux_dir='\$(top_srcdir)/'`expr "$ac_aux_dir" : "$srcdir//*\(.*\)"`
# and then we would define $MISSING as
#   MISSING="\${SHELL} $am_aux_dir/missing"
# This will work as long as MISSING is not called from configure, because
# unfortunately $(top_srcdir) has no meaning in configure.
# However there are other variables, like CC, which are often used in
# configure, and could therefore not use this "fixed" $ac_aux_dir.
#
# Another solution, used here, is to always expand $ac_aux_dir to an
# absolute PATH.  The drawback is that using absolute paths prevent a
# configured tree to be moved without reconfiguration.

AC_DEFUN([AM_AUX_DIR_EXPAND],
[dnl Rely on autoconf to set up CDPATH properly.
AC_PREREQ([2.50])dnl
# expand $ac_aux_dir to an absolute path
am_aux_dir=`cd $ac_aux_dir && pwd`
])

# AM_CONDITIONAL                                            -*- Autoconf -*-

# Copyright (C) 1997, 2000, 2001, 2003, 2004, 2005, 2006, 2008
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 9

# AM_CONDITIONAL(NAME, SHELL-CONDITION)
# -------------------------------------
# Define a conditional.
AC_DEFUN([AM_CONDITIONAL],
[AC_PREREQ(2.52)dnl
 ifelse([$1], [TRUE],  [AC_FATAL([$0: invalid condition: $1])],
	[$1], [FALSE], [AC_FATAL([$0: invalid condition: $1])])dnl
AC_SUBST([$1_TRUE])dnl
AC_SUBST([$1_FALSE])dnl
_AM_SUBST_NOTMAKE([$1_TRUE])dnl
_AM_SUBST_NOTMAKE([$1_FALSE])dnl
m4_define([_AM_COND_VALUE_$1], [$2])dnl
if $2; then
  $1_TRUE=
  $1_FALSE='#'
else
  $1_TRUE='#'
  $1_FALSE=
fi
AC_CONFIG_COMMANDS_PRE(
[if test -z "${$1_TRUE}" && test -z "${$1_FALSE}"; then
  AC_MSG_ERROR([[conditional "$1" was never defined.
Usually this means the macro was only invoked conditionally.]])
fi])])

# Do all the work for Automake.                             -*- Autoconf -*-

# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004,
# 2005, 2006, 2008, 2009 Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 16

# This macro actually does too much.  Some checks are only needed if
# your package does certain things.  But this isn't really a big deal.

# AM_INIT_AUTOMAKE(PACKAGE, VERSION, [NO-DEFINE])
# AM_INIT_AUTOMAKE([OPTIONS])
# -----------------------------------------------
# The call with PACKAGE and VERSION arguments is the old style
# call (pre autoconf-2.50), which is being phased out.  PACKAGE
# and VERSION should now be passed to AC_INIT and removed from
# the call to AM_INIT_AUTOMAKE.
# We support both call styles for the transition.  After
# the next Automake release, Autoconf can make the AC_INIT
# arguments mandatory, and then we can depend on a new Autoconf
# release and drop the old call support.
AC_DEFUN([AM_INIT_AUTOMAKE],
[AC_PREREQ([2.62])dnl
dnl Autoconf wants to disallow AM_ names.  We explicitly allow
dnl the ones we care about.
m4_pattern_allow([^AM_[A-Z]+FLAGS$])dnl
AC_REQUIRE([AM_SET_CURRENT_AUTOMAKE_VERSION])dnl
AC_REQUIRE([AC_PROG_INSTALL])dnl
if test "`cd $srcdir && pwd`" != "`pwd`"; then
  # Use -I$(srcdir) only when $(srcdir) != ., so that make's output
  # is not polluted with repeated "-I."
  AC_SUBST([am__isrc], [' -I$(srcdir)'])_AM_SUBST_NOTMAKE([am__isrc])dnl
  # test to see if srcdir already configured
  if test -f $srcdir/config.status; then
    AC_MSG_ERROR([source directory already configured; run "make distclean" there first])
  fi
fi

# test whether we have cygpath
if test -z "$CYGPATH_W"; then
  if (cygpath --version) >/dev/null 2>/dev/null; then
    CYGPATH_W='cygpath -w'
  else
    CYGPATH_W=echo
  fi
fi
AC_SUBST([CYGPATH_W])

# Define the identity of the package.
dnl Distinguish between old-style and new-style calls.
m4_ifval([$2],
[m4_ifval([$3], [_AM_SET_OPTION([no-define])])dnl
 AC_SUBST([PACKAGE], [$1])dnl
 AC_SUBST([VERSION], [$2])],
[_AM_SET_OPTIONS([$1])dnl
dnl Diagnose old-style AC_INIT with new-style AM_AUTOMAKE_INIT.
m4_if(m4_ifdef([AC_PACKAGE_NAME], 1)m4_ifdef([AC_PACKAGE_VERSION], 1), 11,,
  [m4_fatal([AC_INIT should be called with package and version arguments])])dnl
 AC_SUBST([PACKAGE], ['AC_PACKAGE_TARNAME'])dnl
 AC_SUBST([VERSION], ['AC_PACKAGE_VERSION'])])dnl

_AM_IF_OPTION([no-define],,
[AC_DEFINE_UNQUOTED(PACKAGE, "$PACKAGE", [Name of package])
 AC_DEFINE_UNQUOTED(VERSION, "$VERSION", [Version number of package])])dnl

# Some tools Automake needs.
AC_REQUIRE([AM_SANITY_CHECK])dnl
AC_REQUIRE([AC_ARG_PROGRAM])dnl
AM_MISSING_PROG(ACLOCAL, aclocal-${am__api_version})
AM_MISSING_PROG(AUTOCONF, autoconf)
AM_MISSING_PROG(AUTOMAKE, automake-${am__api_version})
AM_MISSING_PROG(AUTOHEADER, autoheader)
AM_MISSING_PROG(MAKEINFO, makeinfo)
AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
AC_REQUIRE([AM_PROG_INSTALL_STRIP])dnl
AC_REQUIRE([AM_PROG_MKDIR_P])dnl
# We need awk for the "check" target.  The system "awk" is bad on
# some platforms.
AC_REQUIRE([AC_PROG_AWK])dnl
AC_REQUIRE([AC_PROG_MAKE_SET])dnl
AC_REQUIRE([AM_SET_LEADING_DOT])dnl
_AM_IF_OPTION([tar-ustar], [_AM_PROG_TAR([ustar])],
	      [_AM_IF_OPTION([tar-pax], [_AM_PROG_TAR([pax])],
			     [_AM_PROG_TAR([v7])])])
_AM_IF_OPTION([no-dependencies],,
[AC_PROVIDE_IFELSE([AC_PROG_CC],
		  [_AM_DEPENDENCIES(CC)],
		  [define([AC_PROG_CC],
			  defn([AC_PROG_CC])[_AM_DEPENDENCIES(CC)])])dnl
AC_PROVIDE_IFELSE([AC_PROG_CXX],
		  [_AM_DEPENDENCIES(CXX)],
		  [define([AC_PROG_CXX],
			  defn([AC_PROG_CXX])[_AM_DEPENDENCIES(CXX)])])dnl
AC_PROVIDE_IFELSE([AC_PROG_OBJC],
		  [_AM_DEPENDENCIES(OBJC)],
		  [define([AC_PROG_OBJC],
			  defn([AC_PROG_OBJC])[_AM_DEPENDENCIES(OBJC)])])dnl
])
_AM_IF_OPTION([silent-rules], [AC_REQUIRE([AM_SILENT_RULES])])dnl
dnl The `parallel-tests' driver may need to know about EXEEXT, so add the
dnl `am__EXEEXT' conditional if _AM_COMPILER_EXEEXT was seen.  This macro
dnl is hooked onto _AC_COMPILER_EXEEXT early, see below.
AC_CONFIG_COMMANDS_PRE(dnl
[m4_provide_if([_AM_COMPILER_EXEEXT],
  [AM_CONDITIONAL([am__EXEEXT], [test -n "$EXEEXT"])])])dnl
])

dnl Hook into `_AC_COMPILER_EXEEXT' early to learn its expansion.  Do not
dnl add the conditional right here, as _AC_COMPILER_EXEEXT may be further
dnl mangled by Autoconf and run in a shell conditional statement.
m4_define([_AC_COMPILER_EXEEXT],
m4_defn([_AC_COMPILER_EXEEXT])[m4_provide([_AM_COMPILER_EXEEXT])])


# When config.status generates a header, we must update the stamp-h file.
# This file resides in the same directory as the config header
# that is generated.  The stamp files are numbered to have different names.

# Autoconf calls _AC_AM_CONFIG_HEADER_HOOK (when defined) in the
# loop where config.status creates the headers, so we can generate
# our stamp files there.
AC_DEFUN([_AC_AM_CONFIG_HEADER_HOOK],
[# Compute $1's index in $config_headers.
_am_arg=$1
_am_stamp_count=1
for _am_header in $config_headers :; do
  case $_am_header in
    $_am_arg | $_am_arg:* )
      break ;;
    * )
      _am_stamp_count=`expr $_am_stamp_count + 1` ;;
  esac
done
echo "timestamp for $_am_arg" >`AS_DIRNAME(["$_am_arg"])`/stamp-h[]$_am_stamp_count])

# Copyright (C) 2001, 2003, 2005, 2008  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_SH
# ------------------
# Define $install_sh.
AC_DEFUN([AM_PROG_INSTALL_SH],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
if test x"${install_sh}" != xset; then
  case $am_aux_dir in
  *\ * | *\	*)
    install_sh="\${SHELL} '$am_aux_dir/install-sh'" ;;
  *)
    install_sh="\${SHELL} $am_aux_dir/install-sh"
  esac
fi
AC_SUBST(install_sh)])

# Copyright (C) 2003, 2005  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 2

# Check whether the underlying file-system supports filenames
# with a leading dot.  For instance MS-DOS doesn't.
AC_DEFUN([AM_SET_LEADING_DOT],
[rm -rf .tst 2>/dev/null
mkdir .tst 2>/dev/null
if test -d .tst; then
  am__leading_dot=.
else
  am__leading_dot=_
fi
rmdir .tst 2>/dev/null
AC_SUBST([am__leading_dot])])

# Fake the existence of programs that GNU maintainers use.  -*- Autoconf -*-

# Copyright (C) 1997, 1999, 2000, 2001, 2003, 2004, 2005, 2008
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 6

# AM_MISSING_PROG(NAME, PROGRAM)
# ------------------------------
AC_DEFUN([AM_MISSING_PROG],
[AC_REQUIRE([AM_MISSING_HAS_RUN])
$1=${$1-"${am_missing_run}$2"}
AC_SUBST($1)])


# AM_MISSING_HAS_RUN
# ------------------
# Define MISSING if not defined so far and test if it supports --run.
# If it does, set am_missing_run to use it, otherwise, to nothing.
AC_DEFUN([AM_MISSING_HAS_RUN],
[AC_REQUIRE([AM_AUX_DIR_EXPAND])dnl
AC_REQUIRE_AUX_FILE([missing])dnl
if test x"${MISSING+set}" != xset; then
  case $am_aux_dir in
  *\ * | *\	*)
    MISSING="\${SHELL} \"$am_aux_dir/missing\"" ;;
  *)
    MISSING="\${SHELL} $am_aux_dir/missing" ;;
  esac
fi
# Use eval to expand $SHELL
if eval "$MISSING --run true"; then
  am_missing_run="$MISSING --run "
else
  am_missing_run=
  AC_MSG_WARN([`missing' script is too old or missing])
fi
])

# Copyright (C) 2003, 2004, 2005, 2006  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_MKDIR_P
# ---------------
# Check for `mkdir -p'.
AC_DEFUN([AM_PROG_MKDIR_P],
[AC_PREREQ([2.60])dnl
AC_REQUIRE([AC_PROG_MKDIR_P])dnl
dnl Automake 1.8 to 1.9.6 used to define mkdir_p.  We now use MKDIR_P,
dnl while keeping a definition of mkdir_p for backward compatibility.
dnl @MKDIR_P@ is magic: AC_OUTPUT adjusts its value for each Makefile.
dnl However we cannot define mkdir_p as $(MKDIR_P) for the sake of
dnl Makefile.ins that do not define MKDIR_P, so we do our own
dnl adjustment using top_builddir (which is defined more often than
dnl MKDIR_P).
AC_SUBST([mkdir_p], ["$MKDIR_P"])dnl
case $mkdir_p in
  [[\\/$]]* | ?:[[\\/]]*) ;;
  */*) mkdir_p="\$(top_builddir)/$mkdir_p" ;;
esac
])

# Helper functions for option handling.                     -*- Autoconf -*-

# Copyright (C) 2001, 2002, 2003, 2005, 2008  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 4

# _AM_MANGLE_OPTION(NAME)
# -----------------------
AC_DEFUN([_AM_MANGLE_OPTION],
[[_AM_OPTION_]m4_bpatsubst($1, [[^a-zA-Z0-9_]], [_])])

# _AM_SET_OPTION(NAME)
# ------------------------------
# Set option NAME.  Presently that only means defining a flag for this option.
AC_DEFUN([_AM_SET_OPTION],
[m4_define(_AM_MANGLE_OPTION([$1]), 1)])

# _AM_SET_OPTIONS(OPTIONS)
# ----------------------------------
# OPTIONS is a space-separated list of Automake options.
AC_DEFUN([_AM_SET_OPTIONS],
[m4_foreach_w([_AM_Option], [$1], [_AM_SET_OPTION(_AM_Option)])])

# _AM_IF_OPTION(OPTION, IF-SET, [IF-NOT-SET])
# -------------------------------------------
# Execute IF-SET if OPTION is set, IF-NOT-SET otherwise.
AC_DEFUN([_AM_IF_OPTION],
[m4_ifset(_AM_MANGLE_OPTION([$1]), [$2], [$3])])

# Check to make sure that the build environment is sane.    -*- Autoconf -*-

# Copyright (C) 1996, 1997, 2000, 2001, 2003, 2005, 2008
# Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 5

# AM_SANITY_CHECK
# ---------------
AC_DEFUN([AM_SANITY_CHECK],
[AC_MSG_CHECKING([whether build environment is sane])
# Just in case
sleep 1
echo timestamp > conftest.file
# Reject unsafe characters in $srcdir or the absolute working directory
# name.  Accept space and tab only in the latter.
am_lf='
'
case `pwd` in
  *[[\\\"\#\$\&\'\`$am_lf]]*)
    AC_MSG_ERROR([unsafe absolute working directory name]);;
esac
case $srcdir in
  *[[\\\"\#\$\&\'\`$am_lf\ \	]]*)
    AC_MSG_ERROR([unsafe srcdir value: `$srcdir']);;
esac

# Do `set' in a subshell so we don't clobber the current shell's
# arguments.  Must try -L first in case configure is actually a
# symlink; some systems play weird games with the mod time of symlinks
# (eg FreeBSD returns the mod time of the symlink's containing
# directory).
if (
   set X `ls -Lt "$srcdir/configure" conftest.file 2> /dev/null`
   if test "$[*]" = "X"; then
      # -L didn't work.
      set X `ls -t "$srcdir/configure" conftest.file`
   fi
   rm -f conftest.file
   if test "$[*]" != "X $srcdir/configure conftest.file" \
      && test "$[*]" != "X conftest.file $srcdir/configure"; then

      # If neither matched, then we have a broken ls.  This can happen
      # if, for instance, CONFIG_SHELL is bash and it inherits a
      # broken ls alias from the environment.  This has actually
      # happened.  Such a system could not be considered "sane".
      AC_MSG_ERROR([ls -t appears to fail.  Make sure there is not a broken
alias in your environment])
   fi

   test "$[2]" = conftest.file
   )
then
   # Ok.
   :
else
   AC_MSG_ERROR([newly created file is older than distributed files!
Check your system clock])
fi
AC_MSG_RESULT(yes)])

# Copyright (C) 2001, 2003, 2005  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# AM_PROG_INSTALL_STRIP
# ---------------------
# One issue with vendor `install' (even GNU) is that you can't
# specify the program used to strip binaries.  This is especially
# annoying in cross-compiling environments, where the build's strip
# is unlikely to handle the host's binaries.
# Fortunately install-sh will honor a STRIPPROG variable, so we
# always use install-sh in `make install-strip', and initialize
# STRIPPROG with the value of the STRIP variable (set by the user).
AC_DEFUN([AM_PROG_INSTALL_STRIP],
[AC_REQUIRE([AM_PROG_INSTALL_SH])dnl
# Installed binaries are usually stripped using `strip' when the user
# run `make install-strip'.  However `strip' might not be the right
# tool to use in cross-compilation environments, therefore Automake
# will honor the `STRIP' environment variable to overrule this program.
dnl Don't test for $cross_compiling = yes, because it might be `maybe'.
if test "$cross_compiling" != no; then
  AC_CHECK_TOOL([STRIP], [strip], :)
fi
INSTALL_STRIP_PROGRAM="\$(install_sh) -c -s"
AC_SUBST([INSTALL_STRIP_PROGRAM])])

# Copyright (C) 2006, 2008  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 2

# _AM_SUBST_NOTMAKE(VARIABLE)
# ---------------------------
# Prevent Automake from outputting VARIABLE = @VARIABLE@ in Makefile.in.
# This macro is traced by Automake.
AC_DEFUN([_AM_SUBST_NOTMAKE])

# AM_SUBST_NOTMAKE(VARIABLE)
# ---------------------------
# Public sister of _AM_SUBST_NOTMAKE.
AC_DEFUN([AM_SUBST_NOTMAKE], [_AM_SUBST_NOTMAKE($@)])

# Check how to create a tarball.                            -*- Autoconf -*-

# Copyright (C) 2004, 2005  Free Software Foundation, Inc.
#
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# serial 2

# _AM_PROG_TAR(FORMAT)
# --------------------
# Check how to create a tarball in format FORMAT.
# FORMAT should be one of `v7', `ustar', or `pax'.
#
# Substitute a variable $(am__tar) that is a command
# writing to stdout a FORMAT-tarball containing the directory
# $tardir.
#     tardir=directory && $(am__tar) > result.tar
#
# Substitute a variable $(am__untar) that extract such
# a tarball read from stdin.
#     $(am__untar) < result.tar
AC_DEFUN([_AM_PROG_TAR],
[# Always define AMTAR for backward compatibility.
AM_MISSING_PROG([AMTAR], [tar])
m4_if([$1], [v7],
     [am__tar='${AMTAR} chof - "$$tardir"'; am__untar='${AMTAR} xf -'],
     [m4_case([$1], [ustar],, [pax],,
              [m4_fatal([Unknown tar format])])
AC_MSG_CHECKING([how to create a $1 tar archive])
# Loop over all known methods to create a tar archive until one works.
_am_tools='gnutar m4_if([$1], [ustar], [plaintar]) pax cpio none'
_am_tools=${am_cv_prog_tar_$1-$_am_tools}
# Do not fold the above two line into one, because Tru64 sh and
# Solaris sh will not grok spaces in the rhs of `-'.
for _am_tool in $_am_tools
do
  case $_am_tool in
  gnutar)
    for _am_tar in tar gnutar gtar;
    do
      AM_RUN_LOG([$_am_tar --version]) && break
    done
    am__tar="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$$tardir"'
    am__tar_="$_am_tar --format=m4_if([$1], [pax], [posix], [$1]) -chf - "'"$tardir"'
    am__untar="$_am_tar -xf -"
    ;;
  plaintar)
    # Must skip GNU tar: if it does not support --format= it doesn't create
    # ustar tarball either.
    (tar --version) >/dev/null 2>&1 && continue
    am__tar='tar chf - "$$tardir"'
    am__tar_='tar chf - "$tardir"'
    am__untar='tar xf -'
    ;;
  pax)
    am__tar='pax -L -x $1 -w "$$tardir"'
    am__tar_='pax -L -x $1 -w "$tardir"'
    am__untar='pax -r'
    ;;
  cpio)
    am__tar='find "$$tardir" -print | cpio -o -H $1 -L'
    am__tar_='find "$tardir" -print | cpio -o -H $1 -L'
    am__untar='cpio -i -H $1 -d'
    ;;
  none)
    am__tar=false
    am__tar_=false
    am__untar=false
    ;;
  esac

  # If the value was cached, stop now.  We just wanted to have am__tar
  # and am__untar set.
  test -n "${am_cv_prog_tar_$1}" && break

  # tar/untar a dummy directory, and stop if the command works
  rm -rf conftest.dir
  mkdir conftest.dir
  echo GrepMe > conftest.dir/file
  AM_RUN_LOG([tardir=conftest.dir && eval $am__tar_ >conftest.tar])
  rm -rf conftest.dir
  if test -s conftest.tar; then
    AM_RUN_LOG([$am__untar <conftest.tar])
    grep GrepMe conftest.dir/file >/dev/null 2>&1 && break
  fi
done
rm -rf conftest.dir

AC_CACHE_VAL([am_cv_prog_tar_$1], [am_cv_prog_tar_$1=$_am_tool])
AC_MSG_RESULT([$am_cv_prog_tar_$1])])
AC_SUBST([am__tar])
AC_SUBST([am__untar])
]) # _AM_PROG_TAR

dnl -*-m4-*-


dnl This macro provides for a new 'configure' option:
dnl     --with-perl-includes=DIR[:DIR...]
dnl
dnl which provides the following semantics:
dnl
dnl     --with-perl-includes=DIR prepends DIR (or DIRs) to Perl's @INC
dnl
dnl
dnl Multiple directories may be provided by separating the directory names
dnl with a colon (:); this works in the same way as PATH in the Bourne
dnl shell.
dnl
dnl The other AX_PERL5_* macros use this macro to allow the user to
dnl specify the locations of installed Perl 5 modules that may be install
dnl in non-standard locations (that is, any locations that the 'perl'
dnl executable does not search by default).
dnl
dnl Dependencies
dnl ============
dnl 
dnl This macro is not dependent on any macros that are not part of the
dnl core autotools
dnl 
dnl Usage
dnl =====
dnl 
dnl The ads_PERL_INCLUDES macro usually works as an implicit dependency
dnl that is automatically pulled in by explicitly using one of the other
dnl ads_PERL_* macros (such as ads_PERL_MODULE).
dnl 
dnl 
dnl Output
dnl ======
dnl 
dnl     * Shell variable in 'configure':  $ax_perl5_extra_includes
dnl 
dnl         ex. /some/path:/some/other/path
dnl
dnl       Multiple values separated by a colon (':') just like PATH
dnl 
dnl     * Filtering of variable in Autotools input files: @ax_perl5_extra_includes@
dnl       (same value as $ax_perl5_extra_includes
dnl 
dnl     * Filtering of variable in Autotools input files: @ax_perl5_extra_includes@
dnl       (same value as $ax_perl5_extra_includes_opt (see below))
dnl 
dnl     * Automake conditional: USING_PERL5_EXTRA_INCLUDES
dnl       Will be true iff user specified extra include directories via
dnl       the --with-perl-includes command line opt
dnl 
dnl     * Shell variable in 'configure':  $ax_perl5_extra_includes_opt
dnl 
dnl         ex. "\"-I/some/path\" \"-I/some/o t h e r/path\""
dnl
dnl 
dnl       Note that use of this variable by Bourne shell code (or
dnl       derivatives) requires special care. In particular, this variable
dnl       provides it's own quoting for "logically" separate '-I' Perl
dnl       arguments. It must do this because we have to assume that any
dnl       directories supplied by the user may contain spaces in them. On
dnl       the other hand, if the user did not provide any additional '-I'
dnl       directories, then we do not want to pass an empty string
dnl       argument to 'perl'.
dnl
dnl       Here are some examples of naive approaches to using this
dnl       variable (that just happen to work in some circumstances):
dnl
dnl         # WRONG! -- Breaks when no '-I' include paths were provided by
dnl         #           the user (because it creates an empty string arg
dnl         #           to perl).
dnl         #
dnl         #        -- Breaks when any '-I' include paths are provided because
dnl         #           of overquoting.
dnl         MOD='AppConfig'
dnl         "${PERL}" "${ax_perl5_extra_includes_opt}" -we '
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;' "${MOD}"
dnl
dnl
dnl         # WRONG! -- Works when no '-I' include paths were provided by
dnl         #           the user
dnl         #
dnl         #        -- Breaks when any '-I' include paths are provided because
dnl         #           of overquoting.
dnl         MOD='AppConfig'
dnl         "${PERL}" ${ax_perl5_extra_includes_opt} -we '
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;' "${MOD}"
dnl
dnl
dnl         # WRONG! -- Breaks when no '-I' include paths were provided by
dnl         #           the user (because it creates an empty string arg
dnl         #           to perl).
dnl         #
dnl         #        -- Works when any '-I' include paths were provided by
dnl         #           user (regardless of whether or not they have
dnl         #           spaces in them)
dnl         MOD='AppConfig'
dnl         "${PERL}" "$(eval echo ${ax_perl5_extra_includes_opt})" -we '
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;' "${MOD}"
dnl
dnl
dnl         # WRONG! -- Works when no '-I' include paths were provided by
dnl         #           the user
dnl         #
dnl         #        -- Works when all of the '-I' include paths provided
dnl         #           by the user do /not/ contain spaces in them.
dnl         #
dnl         #        -- Breaks when any of the '-I' include paths provided
dnl         #           by the user do contain spaces in them.
dnl         MOD='AppConfig'
dnl         "${PERL}" $(eval echo "${ax_perl5_extra_includes_opt}") -we '
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;' "${MOD}"
dnl
dnl
dnl       The key is to use the shell's builtin 'eval' command with an
dnl       extra layer of quoting around its arguments such that the
dnl       resulting quoting results in $ax_perl5_extra_includes_opt
dnl       providing it's own quoting, and everything else being single
dnl       quoted:
dnl
dnl         # CORRECT!
dnl         eval "'""${PERL}""'" "${ax_perl5_extra_includes_opt}" -we "'"'
dnl             use strict;
dnl             my $m = shift;
dnl             eval "require $m";
dnl             $@ and die $@;'"'" "'""${MOD}""'"
dnl
dnl
dnl Design Notes
dnl ============
dnl
dnl     * We would have liked to use Bash or KornShell (ksh) style
dnl       arrays for storing the values of
dnl       @ax_perl5_extra_includes_opt, but shell arrays are
dnl       non-portable :-(
dnl
dnl
dnl TODO
dnl ====
dnl
dnl     * Add logic to print those directories (if any) found in PERL5LIB
dnl       that were not specified by the user on the command line (for transparency).


AC_DEFUN([ads_PERL_INCLUDES], [

    AC_ARG_WITH([perl-includes],

        [[  --with-perl-includes=DIR[:DIR:...]
                          prepend DIRs to Perl's @INC]],

        [ # AC_ARG_WITH: option if given
            AC_MSG_CHECKING([[for dirs to prepend to Perl's @INC]])

[
            if test "$withval" = "no"  || \
               test "$withval" = "yes" || \
               test -z "$withval"; then
                # The above result from one of the following spefications by the user:
                #
                #     --with-perl-includes=yes
                #     --with-perl-includes=no
                #
                # Both of the above are bogus because they are equivalent to these:
                #
                #     --with-perl-includes
                #     --without-perl-includes
                #
                # The DIR param is required.
]
                AC_MSG_ERROR([[missing argument to --with-perl-includes]])
[
            else

                # Verify that the user-specified directory (or directories) exists. Build
                # up our internal ax_perl5_* variables at the same time.
                _tmp_results_string=''
                IFShold=$IFS
                IFS=':'
                for _tdir in ${withval}; do
                    if test -d "${_tdir}"; then :; else
                        IFS=$IFShold
]
                        AC_MSG_ERROR([no such directory: ${_tdir}])
[
                    fi

                    if test -z "$ax_perl5_extra_includes"; then
                        ax_perl5_extra_includes="${_tdir}"
                        ax_perl5_extra_includes_opt="-I\"${_tdir}\""  # for passing on 'perl' command line, if needed
                        _tmp_results_string="`printf "\n    ${_tdir}"`"
                    else
                        ax_perl5_extra_includes="${ax_perl5_extra_includes}:${_tdir}"
                        ax_perl5_extra_includes_opt=${ax_perl5_extra_includes_opt}" -I\"${_tdir}\""
                        _tmp_results_string="${_tmp_results_string}`printf "\n    ${_tdir}"`"
                    fi
                done
                IFS=$IFShold
]
                AC_MSG_RESULT([${_tmp_results_string}])
[
            fi
]
        ],

        [ # AC_ARG_WITH: option if not given, same as --without-perl-includes
            AC_MSG_CHECKING([[for dirs to prepend to Perl's @INC]])
            AC_MSG_RESULT([[none]])
        ]
    )dnl end fo AC_ARG_WITH(perl-includes) macro

    AC_SUBST([ax_perl5_extra_includes])
    AC_SUBST([ax_perl5_extra_includes_opt])

    dnl register a conditional for use in Makefile.am files
    AM_CONDITIONAL([USING_PERL5_EXTRA_INCLUDES], [test -n "${ax_perl5_extra_includes}"])
])

dnl -*-Autoconf-*-


dnl This macro provides for a new 'configure' option:
dnl     --with-perl-libdir=DIR
dnl
dnl which provides the following semantics:
dnl
dnl     --without-perl-libdir AKA --with-perl-libdir=no uses $pkglibdir (the default).
dnl     --with-perl-libdir AKA --with-perl-libdir=yes uses 'perl -V:installsitelib'.
dnl     --with-perl-libdir=DIR uses specified DIR
dnl
dnl This macro provides "autoconfiscated" software packages with a means
dnl of installing Perl library modules in a way that is consistent with
dnl other packages that use the GNU autotools, yet also allows perl modules
dnl to be installed like CPAN modules.
dnl
dnl Dependencies:
dnl ------------
dnl This macro expects that the shell variables $SED and $PERL are
dnl set and that their values are the paths to the 'sed' and 'perl'
dnl executables.
dnl
dnl The macro provides the 'PERL_LIBDIR' automake variable to indicate where
dnl perl library modules should be installed. It also provides the automake
dnl conditional 'USING_PERL_INSTALLSITELIB'. See below for details.
dnl
dnl The default behavior of this macro is to set up PERL_LIBDIR to install
dnl perl modules in $pkglibdir/perl5; this is to make it consistent with other
dnl automake macros in that the '--prefix=DIR' configure option is respected.
dnl The downside to this default behavior is that Perl scripts that need to
dnl access the installed modules may need to take special measures (add
dnl a 'use lib' pragma or manipulate @INC directly) to be able to find the
dnl modules; see the 'USING_PERL_INSTALLSITELIB' automake conditional below
dnl for one tool that may be used to handle this condition at configure time.
dnl The default behavior is what you get when the '--with-perl-libdir' option
dnl is not passed to configure, or when it is passed in the following forms:
dnl     --with-perl-libdir=no
dnl     --without-perl-libdir
dnl 
dnl When specified as
dnl     --with-perl-libdir
dnl or
dnl     --with-perl-libdir=yes
dnl the macro will determine where to install the perl modules by asking the
dnl perl interpreter where it will look for installed site libraries. This is
dnl how CPAN user's expect to be able to install Perl modules (that is, the
dnl installation procedure ask the existing Perl installation where it will
dnl be able to find installed modules, and then installs the modules
dnl accordingly), and would be the default behavior except for the fact that
dnl it ignores the '--prefix=DIR' configure option (when setting PERL_LIBDIR),
dnl and could therefore be destructive if the user was not expecting that.
dnl Packages that use this macro may wish to recommend this form of
dnl '--with-perl-libdir' to user's in a README or INSTALL file. This
dnl installation method is accomplished by extracting the directory path from
dnl the output of the command:
dnl     $ perl -V:installsitelib
dnl 
dnl The third and final way to use the '--with-perl-libdir' configure option
dnl is like this:
dnl     --with-perl-libdir=DIR
dnl When run this way, PERL_LIBDIR simply gets set to the value of DIR.
dnl
dnl
dnl To use this macro, simply put the following in your configure.in:
dnl     ads_PERL_LIBDIR
dnl
dnl This macro sets up the shell variable:
dnl
dnl     $PERL_LIBDIR, which will contain a directory name at the
dnl               end of the macro
dnl
dnl This macro sets up the automake var @PERL_LIBDIR@ with the value in the
dnl $PERL_LIBDIR shell variable. This automake var is provided for use in
dnl Makefile.am files.
dnl
dnl This macro also sets up the automake conditional 'USING_PERL_INSTALLSITELIB'
dnl to indicate whether or not the value of PERL_LIBIDR was set using the value
dnl returned from the perl interpreter for 'installsitelib'.
dnl
dnl
dnl CREDITS
dnl     * This macro was written by Alan D. Salewski <salewski AT worldnet.att.net>,
dnl       using code extracted from earlier efforts.
dnl
dnl     * The name and semantics of the '--with-perl-libdir' configure option are
dnl       an immense improvement over the original effort; these were suggested
dnl       by Ralph Schleicher <ralph.schleicher AT lli.liebherr.com>
dnl

AC_DEFUN([ads_PERL_LIBDIR], [

    AC_REQUIRE([ads_PROG_PERL])

    AC_ARG_WITH(perl-libdir,

     changequote(<<, >>)dnl
<<  --with-perl-libdir[=ARG]
                          where to install perl modules [ARG=no, uses \$pgklibdir/perl5]>>dnl
     changequote([, ])dnl
    ,
    [ # AC_ARG_WITH: option if given
    AC_MSG_CHECKING(for where to install perl modules)
    # each condition sets 'using_perlsysdirs' to either "yes" or "no", and
    # sets 'PERL_LIBDIR' to a non-empty DIR value
    if test "$withval" = "no"; then
        # --with-perl-libdir=no AKA --without-perl-libdir uses $pkglibdir (dflt)
        using_perlsysdirs="no"

        # note that we're constructing pkglibdir as automake would, but not
        # using the shell variable directly; this is because automake (at least
        # as of 1.4-p5) only defines '$pkglibdir' in the generated Makefile.in
        # files, but not in 'configure.in'. We need it defined in configure
        # in order for the assignment to PERL_LIBDIR to work.
        PERL_LIBDIR=${libdir}/${PACKAGE}/perl5
        AC_MSG_RESULT(\$pkglibdir: ${libdir}/${PACKAGE}/perl5)
    elif test -z "$withval" || \
         test "$withval" = "yes"; then
        # --with-perl-libdir AKA --with-perl-libdir=yes uses 'perl -V:installsitelib'
        using_perlsysdirs="yes"
        AC_MSG_RESULT(Perl's "installsitelib")

        AC_MSG_CHECKING(for perl installsitelib dir)
        PERL_LIBDIR=`$PERL '-V:installsitelib*' | \
                     $SED -e "s/^installsitelib=[']\(.*\)[']\$/\1/"`
        if test "${PERL_LIBDIR}" = "undef" || \
           test "${PERL_LIBDIR}X" = "X"; then
            tmp_valid_opts="`printf "\t"`"`$PERL -le 'print join $/."\t", @INC'`
            AC_MSG_ERROR([
    Perl\'s installsitelib is not defined, and this is the preferred
    location in which to install the perl libraries included with ${PACKAGE}.
    Of course, you may specify that the perl libraries be installed anywhere
    perl will find them (anywhere in the @INC array), but you must explicitely
    request where, as this is non-standard. You may specify where to place them
    by using the \'--with-perl-libdir=DIR\' option to \'configure\'. All of the
    following are in @INC:
$tmp_valid_opts
])
        fi
        AC_MSG_RESULT($PERL_LIBDIR)

    else
        # --with-perl-libdir=DIR, use user-specified directory
        using_perlsysdirs="no"
        PERL_LIBDIR="${withval}"
        AC_MSG_RESULT(specified dir: $withval)
        dnl DEBUG: FIXME: warn the user if dir not in @INC?
    fi
    ],
    [ # AC_ARG_WITH: option if not given, same as --without-perl-libdir
    AC_MSG_CHECKING(for where to install perl modules)

    # note that we're constructing pkglibdir as automake would, but not
    # using the shell variable directly; this is because automake (at least
    # as of 1.4-p5) only defines '$pkglibdir' in the generated Makefile.in
    # files, but not in 'configure.in'. We need it defined in configure
    # in order for the assignment to PERL_LIBDIR to work.
    PERL_LIBDIR=${libdir}/${PACKAGE}/perl5
    AC_MSG_RESULT(\$pkglibdir: ${libdir}/${PACKAGE}/perl5)
    ])dnl end of AC_ARG_WITH(perl-libdir) macro

    AC_SUBST(PERL_LIBDIR)
    dnl register a conditional for use in Makefile.am files
    AM_CONDITIONAL(USING_PERL_INSTALLSITELIB, test x$using_perlsysdirs = x$yes)
])


dnl -*-m4-*-
dnl 
dnl ##
dnl ## $Id$
dnl ##
dnl 
dnl This file provides the 'ads_PERL_MODULE' autoconf macro, which may be
dnl used to add checks in your 'configure.ac' file for a specific Perl
dnl module.
dnl 
dnl By default, the specified module is "required"; if it is not found,
dnl the 'configure' program will print an error message and exit with an
dnl error status (via AC_MSG_ERROR). However, you may pass a parameter
dnl indicating that the module is optional; in that case 'configure' will
dnl simply print a message indicating that the module was not found and
dnl continue on.
dnl 
dnl Dependencies
dnl ============
dnl 
dnl This macro contains an automatic dependency on the 'ads_PROG_PERL'
dnl autoconf macro to set the $PERL shell variable to the path of the
dnl configured Perl interpreter.
dnl 
dnl Usage
dnl =====
dnl 
dnl ads_PERL_MODULE(PERL_MODULE_NAME, [REQUIRED|OPTIONAL], [PERL_MODULE_VERSION])
dnl 
dnl     * The PERL_MODULE_NAME param is required.
dnl 
dnl     * The second param is optional, and defaults to the constant 'REQUIRED'.
dnl 
dnl     * The PERL_MODULE_VERSION param is optional. If not specified,
dnl       then 'configure' will be satisfied if /any/ version of the
dnl       module is found. Note that the specified version is /not/
dnl       absolute; we use the Perl interpreter to determine whether or
dnl       not the version requirement is satisfied (which checks the
dnl       module's $VERSION property), so it is essentially a check for
dnl       "the specified version number or newer". See the perlmodlib(1)
dnl       in the Perl documentation for all the details.
dnl 
dnl Examples
dnl ========
dnl 
dnl The following examples show snippets that would be placed in your
dnl 'configure.ac' file.
dnl 
dnl Example 1
dnl ---------
dnl 
dnl     ## Module 'Foo::Bar::Baz' is required (any version)
dnl     ads_PERL_MODULE([Foo::Bar::Baz])
dnl 
dnl Example 2
dnl ---------
dnl 
dnl     ## Same as Example 1, only more explicit
dnl     ads_PERL_MODULE([Foo::Bar::Baz], [REQUIRED])
dnl 
dnl Example 3
dnl ---------
dnl 
dnl     ## Version 0.02 of module 'Foo::Bar::Baz' is required
dnl     ads_PERL_MODULE([Foo::Bar::Baz], [REQUIRED], [0.02])
dnl 
dnl 
dnl Design Notes
dnl ============
dnl
dnl Required/Optional Param
dnl -----------------------
dnl Note that in order to specify the module version number, you must
dnl specify either 'REQUIRED' or 'OPTIONAL' as the second macro parameter.
dnl 
dnl An alternative interface design would make the version number the
dnl second param, and the 'REQUIRED' or 'OPTIONAL' param would always be
dnl optional.
dnl 
dnl The existing interface was decided on in order to optimize for the
dnl common case. The presumption, obviously, is that users of the macro
dnl will need to specify that a module is required or optional more often
dnl than they will need to specify a dependency on a particular version of
dnl the module. Moreover, users probably do /not/ want to specify a
dnl version number (or use hacks such as '0.00') when all they really want
dnl to do is indicate that a module is required or optional.
dnl
dnl
dnl Module Version Number Output
dnl ----------------------------
dnl 
dnl If the user requests a specifc version number of the specified module,
dnl then we display both the requested version number (as part of the
dnl "checking for" message) and the version actually found (as part of the
dnl result message). For these modules, a version number is required, and
dnl 'configure' will bomb out even if the module is found, but does not
dnl specify a version number (note that in this case, 'configure' actually
dnl stops as a result of 'perl' exiting with an error status when we
dnl request such a module, so we're behaving consistently with
dnl Perl). Here's some example output:
dnl 
dnl     checking for for LWP::UserAgent 2.000... (2.033) /usr/share/perl5/LWP/UserAgent.pm
dnl 
dnl If the user did not request a specific version number, we still print
dnl out the version number found if we're able to determine it:
dnl 
dnl     checking for for LWP::UserAgent ... (2.033) /usr/share/perl5/LWP/UserAgent.pm
dnl 
dnl If the usre did not request a specific version number, and the module
dnl doesn't provide a version number (according to Perl's Exporter module
dnl conventions), then we simply show '???' for the version number:
dnl 
dnl     checking for for CJ::Util::MakeMod... (???) /some/path/to/perl/lib/CJ/Util/MakeMod.pm
dnl 
dnl 
dnl 
dnl TODO
dnl ====
dnl     * Add use of (not yet existing) facility to include maintainer
dnl       name and email address information for inclusion in error
dnl       messages that detect bugs in the macro.
dnl 
dnl     * Maybe set HAVE_PERL5_MODULE_FOO_BAR_BAZ automake conditional
dnl 
dnl     * Maybe set @HAVE_PERL5_MODULE_FOO_BAR_BAZ@ automake variable
dnl 


AC_DEFUN([ads_PERL_MODULE], [

    AC_REQUIRE([ads_PROG_PERL])
    AC_REQUIRE([ads_PERL_INCLUDES])

[
    _tmp_macro_name='ads_PERL_MODULE.m4'

    # (required) This should be something like Foo::Bar::Baz
    _tmp_perl_mod_name=$1
    if test -z "${_tmp_perl_mod_name}"; then
        # This is almost certainly a programmer error
]
        AC_MSG_ERROR([[
    ${_tmp_macro_name} ERROR: required 'PERL_MODULE_NAME' param not provided

    Usage:
        ${_tmp_macro_name}(PERL_MODULE_NAME, [REQUIRED|OPTIONAL], [PERL_MODULE_VERSION])
]])
[
    fi

    # (optional) If not provided, then we assume that the Perl
    # module is required. Valid values are 'REQUIRED' or 'OPTIONAL'.
    _tmp_perl_mod_required_or_optional=$2
    if test -z "${_tmp_perl_mod_required_or_optional}"; then
        _tmp_perl_mod_required_or_optional='REQUIRED'  # dflt
    fi
    if test "${_tmp_perl_mod_required_or_optional}" = 'REQUIRED' ||
       test "${_tmp_perl_mod_required_or_optional}" = 'OPTIONAL'; then :; else
]
        AC_MSG_ERROR([[
    ${_tmp_macro_name} ERROR: second macro param must be either 'REQUIRED' or 'OPTIONAL' (got "${_tmp_perl_mod_required_or_optional}")

    Usage:
        ${_tmp_macro_name}(PERL_MODULE_NAME, [REQUIRED|OPTIONAL], [PERL_MODULE_VERSION])
]])
[
    fi

    # (optional) If provided, this should be the perl module version
    _tmp_perl_mod_version=$3

    _tmp_check_msg="for ${_tmp_perl_mod_name}"
    if test -n "${_tmp_perl_mod_version}"; then
        _tmp_check_msg="${_tmp_check_msg} ${_tmp_perl_mod_version}"
    fi

    _tmp_perl_mod_msg_version="${_tmp_perl_mod_version}"
    if test -z "${_tmp_perl_mod_version}"; then
        _tmp_perl_mod_msg_version='(any version)'
    fi
]
    AC_MSG_CHECKING([[for ${_tmp_check_msg}]])
[
    # Invoking perl twice is inefficient, but better isolates our test

    # Only redirect stderr to /dev/null if module is optional. This prevents
    # Perl's error messages from cluttering up the 'configure' output with
    # error messages that may look to the user as though something is wrong.
    #
    if test "${_tmp_perl_mod_required_or_optional}" = 'REQUIRED'; then
        eval "'""${PERL}""'" "${ax_perl5_extra_includes_opt}" \
                  -we "'""use strict; use ${_tmp_perl_mod_name} ${_tmp_perl_mod_version};""'"
    else

        eval "'""${PERL}""'" "${ax_perl5_extra_includes_opt}" \
                  -we "'""use strict; use ${_tmp_perl_mod_name} ${_tmp_perl_mod_version};""'" 2>/dev/null
    fi
    if test $? -eq 0; then
        # Great, we have the module. Now print where it was found:
        _tmp_perl_mod_path="$( eval "'""${PERL}""'" "${ax_perl5_extra_includes_opt}" \
          -MFile::Spec -wle "'"'
            use strict;
            my $modname = shift;
            eval "require ${modname}";
            ${@} and die qq{Was unable to require module "$modname": ${@}};
            $modname .= q{.pm};
            my $found = undef;
            my $shortpath = File::Spec->catdir( split(q{::}, $modname) );
            my $fullpath;
            if (exists $INC{ $shortpath } && defined $INC{ $shortpath }) {
                $found = 1;
                $fullpath = $INC{ $shortpath };
            }
            $fullpath = q{<path unavailable in %INC}
                unless defined $fullpath && length $fullpath;
            print $fullpath;
            exit ($found ? 0 : 1);  # parens required
        '"'" "'""${_tmp_perl_mod_name}""'")"
        if test $? -ne 0; then
]

dnl FIXME: provide macro maintainer email address in error message

            AC_MSG_ERROR([[
    Perl module ${_tmp_perl_mod_name} exists, but 'configure' was unable to
    determine the path to the module. This is likely a bug in the ${_tmp_macro_name}
    autoconf macro; please report this as a bug.
]])
[
        fi

        # Always attempt to determine the version number of the module
        # that was acutally found and display it to the user. Not all
        # Perl modules provide a $VERSION variable, but if the one
        # we're testing for does, then we'll show it.
        #
        # Note that we do this even for those modules for which the
        # user has requested a specific version because the
        # user-specified version is understood as "this version or
        # newer", so may be different from the version of the module
        # actually found on the system.

        _tmp_found_mod_version="$(
          eval "'""${PERL}""'" "'""-M${_tmp_perl_mod_name}""'" \
            "${ax_perl5_extra_includes_opt}" -wle "'"'
               my $modname = shift;
               my $ver = "${modname}::VERSION";
               print $$ver if defined $$ver && length $$ver;
            '"'" "'""${_tmp_perl_mod_name}""'"
        )"
        if test $? -ne 0; then
]
                AC_MSG_ERROR([[
    Perl module ${_tmp_perl_mod_name} exists, but 'configure' was unable to
    test whether or not the module specifies a version number. This is likely
    a bug in the ${_tmp_macro_name} autoconf macro; please report this as a bug.
]])
[
        fi

        if test "${_tmp_found_mod_version}x" = 'x'; then
            # Module does not provide version info, so use bogon string
            _tmp_perl_mod_path="(???) ${_tmp_perl_mod_path}"
        else
            # Prepend the value to the module path for display to the user
            _tmp_perl_mod_path="(${_tmp_found_mod_version}) ${_tmp_perl_mod_path}"
        fi
]
        AC_MSG_RESULT([[${_tmp_perl_mod_path}]])
[
    else
        if test "${_tmp_perl_mod_required_or_optional}" = 'REQUIRED'; then
]
            AC_MSG_ERROR([[
    Was unable to locate Perl module ${_tmp_perl_mod_name} ${_tmp_perl_mod_msg_version}
]])
[
        else  # presence of module was optional
]
            AC_MSG_RESULT([[no (ok)]])
[
        fi
    fi
]
])

dnl FIXME: Maybe provide an autoconf flag indicating whether or not
dnl        the Perl module was found.

dnl -*- m4 -*-


dnl ads_PROG_PERL([required_perl_version])
dnl
dnl This macro tests for the existence of a perl interpreter on the
dnl target system. By default, it looks for perl version 5.005 or
dnl newer; you can change the default version by passing in the
dnl optional 'required_perl_version' argument, setting it to the perl
dnl version you want. The format of the 'required_perl_version' argument
dnl string is anything that you could legitimately use in a perl
dnl script, but see below for a note on the format of the perl version
dnl argument and compatibility with older perl interpreters.
dnl
dnl If no perl interpreter of the the required minimum version is found,
dnl then we bomb out with an error message.
dnl
dnl To use this macro, just drop it in your configure.in file as
dnl indicated in the examples below. Then use @PERL@ in any of your
dnl files that will be processed by automake; the @PERL@ variable
dnl will be expanded to the full path of the perl interpreter.
dnl
dnl Examples:
dnl     ads_PROG_PERL              (looks for 5.005, the default)
dnl     ads_PROG_PERL()            (same effect as previous)
dnl     ads_PROG_PERL([5.006])     (looks for 5.6.0, preferred way)
dnl     ads_PROG_PERL([5.6.0])     (looks for 5.6.0, don't do this)
dnl
dnl Note that care should be taken to make the required perl version
dnl backward compatible, as explained here:
dnl     http://www.perldoc.com/perl5.8.0/pod/func/require.html
dnl That is why the '5.006' form is preferred over '5.6.0', even though
dnl both are for perl version 5.6.0
dnl
dnl CREDITS
dnl     * This macro was written by Alan D. Salewksi <salewski AT worldnet.att.net>

AC_DEFUN([ads_PROG_PERL], [
    req_perl_version="$1"
    if test -z "$req_perl_version"; then
        req_perl_version="5.005"
    fi
    AC_PATH_PROG(PERL, perl)
    if test -z "$PERL"; then
        AC_MSG_ERROR([perl not found])
    fi
    $PERL -e "require ${req_perl_version};" || {
        AC_MSG_ERROR([perl $req_perl_version or newer is required])
    }
])


AC_DEFUN([AX_DISTCHECK_HACK], [

    AC_MSG_CHECKING([[whether to enable distcheck hacking]])

    AC_ARG_ENABLE([distcheck-hack],
        [[  --enable-distcheck-hack      configure distcheck_hack, exposes $DISTCHECK_HACK_ENABLED]],

        dnl AC_ARG_ENABLE: option if given
        [
            case "${enableval}" in
                yes)  DISTCHECK_HACK_ENABLED=true  ;;
                no)   DISTCHECK_HACK_ENABLED=false ;;
                *)
                    AC_MSG_ERROR([bad value ("$enableval") for '--enable-distcheck-hack' option])
                    ;;
            esac
        ],

        dnl AC_ARG_ENABLE: option if not given
        [
            DISTCHECK_HACK_ENABLED=false
        ]
    )

    if ${DISTCHECK_HACK_ENABLED}; then
        AC_MSG_RESULT([yes])
    else
        AC_MSG_RESULT([no])
    fi

    dnl register a conditional for use in Makefile.am files
    AM_CONDITIONAL([DISTCHECK_HACK_ENABLED], [${DISTCHECK_HACK_ENABLED}])
])


