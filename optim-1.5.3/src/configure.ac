#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.
#
### Copyright (C) 2015-2018 Olaf Till <i7tiol@t-online.de>
###
### This program is free software; you can redistribute it and/or
### modify it under the terms of the GNU General Public License as
### published by the Free Software Foundation; either version 3 of the
### License, or (at your option) any later version.
###
### This program is distributed in the hope that it will be useful,
### but WITHOUT ANY WARRANTY; without even the implied warranty of
### MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
### General Public License for more details.
###
### You should have received a copy of the GNU General Public License
### along with this program; if not, see
### <http://www.gnu.org/licenses/>.

AC_PREREQ([2.62])
AC_INIT([optim], [1.5.3], [i7tiol@t-online.de])
AC_CONFIG_SRCDIR([numgradient.cc])
AC_CONFIG_HEADERS([config.h])

# Avoid warnings for redefining AH-generated preprocessor symbols of
# Octave.
AH_TOP([#include "undef-ah-octave.h"])

AC_CONFIG_MACRO_DIRS([m4])

# Checks for programs.
AC_CHECK_PROG(MKOCTFILE, mkoctfile, mkoctfile)
if test -z "$MKOCTFILE"; then
AC_MSG_ERROR([mkoctfile not found], 1);
fi
AC_CHECK_PROG(OCTAVE_CONFIG, octave-config, octave-config)
if test -z "$OCTAVE_CONFIG"; then
AC_MSG_ERROR([octave-config not found], 1);
fi

AC_PROG_SED

# The same value of CXX as Octave was compiled with is supposed to be used.
CXX=${CXX:-`${MKOCTFILE} -p CXX`}
AC_PROG_CXX

AC_PROG_CXXCPP

# Checks for libraries.

# Checks for header files.
AC_CHECK_HEADERS([float.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL

# Checks for library functions.
AC_FUNC_ERROR_AT_LINE
AC_CHECK_FUNCS([sqrt])

# Start of checks for Octave features, preparations for checks.
OCTLIBDIR=${OCTLIBDIR:-`$OCTAVE_CONFIG -p OCTLIBDIR`}
## We need Octaves include path both with and without '/octave'
## appended. The path without '/octave' is needed to selectively test
## for Octave headers, like octave/....h. The path with '/octave' is
## needed since some Octave headers contain include directives for
## other Octave headers with <> instead of "".
OCTINCLUDEDIR=${OCTINCLUDEDIR:-`$MKOCTFILE -p INCFLAGS`}
AC_LANG_PUSH([C++])
TCXXFLAGS=$CXXFLAGS
TLDFLAGS=$LDFLAGS
TLIBS=$LIBS
TCPPFLAGS=$CPPFLAGS
LDFLAGS="-L$OCTLIBDIR $LDFLAGS"
LIBS="-loctinterp $LIBS"
# CXXFLAGS=
CPPFLAGS="$OCTINCLUDEDIR $CPPFLAGS"

## Presence of 'error_state' -- does _not_ indicate no exceptions are
## used.
AC_LINK_IFELSE(
  [AC_LANG_PROGRAM([[#include <octave/oct.h>]
                    [#include <stdio.h>]],
                   [[printf ("%i", error_state);]])],
  [AC_DEFINE([HAVE_OCTAVE_ERROR_STATE], 1,
    [Define as 1 if liboctinterp is old enough to provide error_state.])])

## Presence of 'verror (octave(_|::)execution_exception&, const char *,
## va_list)'
AC_COMPILE_IFELSE(
  [AC_LANG_PROGRAM([[#include <octave/oct.h>]],
                   [[octave_execution_exception e;]
                    [va_list args;]
                    [verror (e, "test", args);]])],
  [AC_DEFINE([HAVE_OCTAVE_VERROR_ARG_EXC], 1,
    [Define as 1 if liboctinterp has 'verror (octave(_|::)execution_exception&, const char *, va_list)'.])],
  [AC_COMPILE_IFELSE(
    [AC_LANG_PROGRAM([[#include <octave/oct.h>]],
                     [[octave::execution_exception e;]
                      [va_list args;]
                      [verror (e, "test", args);]])],
    [AC_DEFINE([HAVE_OCTAVE_VERROR_ARG_EXC], 1,
      [Define as 1 if liboctinterp has 'verror (octave(_|::)execution_exception&, const char *, va_list)'.])])])

## Simple symbol alternatives of different Octave versions.
OF_OCTAVE_LIST_ALT_SYMS([
[dnl
  [feval],
  [octave::feval],
  [[octave::feval ("date");]],
  [OCTAVE__FEVAL],
  [[#include <octave/parse.h>]],
  [[#include <octave/parse.h>]]
],

[dnl
  [xisnan],
  [octave::math::isnan],
  [[float f = 0; octave::math::isnan (f);]],
  [OCTAVE__MATH__ISNAN],
  [],
  [[#include <octave/lo-mappers.h>]]
],

[dnl
  [is_cell],
  [iscell],
  [[octave_value ().iscell ();]],
  [OV_ISCELL],
  [],
  []
],

[dnl
  [octave_execution_exception],
  [octave::execution_exception],
  [[octave::execution_exception ();]],
  [OCTAVE__EXECUTION_EXCEPTION],
  [],
  []
]

],
   [oct-alt-includes.h])

LIBS=$TLIBS
LDFLAGS=$TLDFLAGS
CXXFLAGS=$TCXXFLAGS
CPPFLAGS=$TCPPFLAGS
AC_LANG_POP([C++])
# End of checks for Octave features.

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
