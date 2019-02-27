/*

Copyright (C) 2016-2018 Olaf Till <i7tiol@t-online.de>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; If not, see <http://www.gnu.org/licenses/>.

*/

#include "config.h"

// Octaves non-static verror functions: The elder all set error_state,
// the newer, present from the time on at which error started to throw
// an exception, all throw, too.

// call verror, for _linking_ also against Octave versions who have no
// verror() with these arguments
#ifdef HAVE_OCTAVE_VERROR_ARG_EXC
void c_verror (OCTAVE__EXECUTION_EXCEPTION&, const char *, ...);
#else
void c_verror (const OCTAVE__EXECUTION_EXCEPTION&, const char *, ...);
#endif

void _p_error (const char *fmt, ...);

// Print a message if 'code' causes an error and raise an error again,
// both if Octave uses exceptions for errors and if it still uses
// error_state. In the latter case return 'retval'.
#ifdef HAVE_OCTAVE_ERROR_STATE
  // can throw OCTAVE__EXECUTION_EXCEPTION despite of this
  #define CHECK_ERROR(code, retval, ...)      \
    try \
      { \
        code ; \
 \
        if (error_state) \
          { \
            error (__VA_ARGS__); \
 \
            return retval; \
          } \
      } \
    catch (OCTAVE__EXECUTION_EXCEPTION& e) \
      { \
        c_verror (e, __VA_ARGS__); \
      }
#else
  #define CHECK_ERROR(code, retval, ...) \
    try \
      { \
        code ; \
      } \
    catch (OCTAVE__EXECUTION_EXCEPTION& e) \
      { \
        verror (e, __VA_ARGS__); \
      }
#endif

// If 'code' causes an error, print a message and call exit(1) if
// Octave doesn't throw exceptions for errors but still uses
// error_state.
#ifdef HAVE_OCTAVE_ERROR_STATE
  // can throw OCTAVE__EXECUTION_EXCEPTION despite of this
  #define CHECK_ERROR_EXIT1(code, ...) \
    try \
      { \
        code ; \
 \
        if (error_state) \
          { \
            _p_error (__VA_ARGS__); \
 \
            exit (1); \
          } \
      } \
    catch (OCTAVE__EXECUTION_EXCEPTION&) \
      { \
        _p_error (__VA_ARGS__); \
 \
        exit (1); \
      }
#else
  #define CHECK_ERROR_EXIT1(code, ...) \
    try \
      { \
        code ; \
      } \
    catch (OCTAVE__EXECUTION_EXCEPTION&) \
      { \
        _p_error (__VA_ARGS__); \
 \
        exit (1); \
      }
#endif

// Set 'err' to true if 'code' causes an error, else to false; both if
// Octave uses exceptions for errors and if it still uses
// error_state. In the latter case reset error_state to 0.
#ifdef HAVE_OCTAVE_ERROR_STATE
  // can throw OCTAVE__EXECUTION_EXCEPTION despite of this
  #define SET_ERR(code, err) \
    err = false; \
 \
    try \
      { \
        code ; \
        if (error_state) \
          { \
            error_state = 0; \
            err = true; \
          } \
      } \
    catch (OCTAVE__EXECUTION_EXCEPTION&) \
      { \
        err = true; \
      }
#else
  #define SET_ERR(code, err) \
    err = false; \
 \
    try \
      { \
        code ; \
      } \
    catch (OCTAVE__EXECUTION_EXCEPTION&) \
      { \
        err = true; \
      }
#endif
