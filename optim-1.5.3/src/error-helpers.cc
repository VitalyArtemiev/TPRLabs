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

#include <octave/oct.h>

#include "error-helpers.h"

// call verror
#ifdef HAVE_OCTAVE_VERROR_ARG_EXC
void
c_verror (OCTAVE__EXECUTION_EXCEPTION& e, const char *fmt, ...)
{
  va_list args;
  va_start (args, fmt);
  verror (e, fmt, args);
  va_end (args);
}
#else
void
c_verror (const OCTAVE__EXECUTION_EXCEPTION&, const char *fmt, ...)
{
  va_list args;
  va_start (args, fmt);
  verror (fmt, args);
  va_end (args);
}
#endif

void
_p_error (const char *fmt, ...)
{
  va_list args;
  va_start (args, fmt);

  std::ostringstream output_buf;

  octave_vformat (output_buf, fmt, args);

  std::string msg = output_buf.str ();

  if (msg[msg.length () - 1] != '\n')
    msg += "\n";

  std::cerr << msg;

  va_end (args);
}
