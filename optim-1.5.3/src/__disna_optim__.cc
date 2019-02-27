// Copyright (C) 2011-2016 Olaf Till <olaf.till@uni-jena.de>
//
// This program is free software; you can redistribute it and/or modify it under
// the terms of the GNU General Public License as published by the Free Software
// Foundation; either version 3 of the License, or (at your option) any later
// version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
// details.
//
// You should have received a copy of the GNU General Public License along with
// this program; if not, see <http://www.gnu.org/licenses/>.

// This function has also been submitted to Octave (bug #33503).

#include <octave/oct.h>
#include <f77-fcn.h>

#include "error-helpers.h"

#if defined (OCTAVE_HAVE_F77_INT_TYPE)
#  define TO_F77_INT(x) octave::to_f77_int (x)
#else
typedef octave_idx_type F77_INT;
#  define TO_F77_INT(x) (x)
#endif

extern "C"
{
  F77_RET_T
  F77_FUNC (ddisna, DDISNA) (F77_CONST_CHAR_ARG_DECL,
                             const F77_INT&,
                             const F77_INT&,
                             const double*,
                             double*,
                             F77_INT&);

  F77_RET_T
  F77_FUNC (sdisna, SDISNA) (F77_CONST_CHAR_ARG_DECL,
                             const F77_INT&,
                             const F77_INT&,
                             const float*,
                             float*,
                             F77_INT&);
}

DEFUN_DLD (__disna_optim__, args, ,
  "-*- texinfo -*-\n\
@deftypefn {Loadable Function} {@var{rcond} =} __disna__ (@var{job}, @var{d})\n\
@deftypefnx {Loadable Function} {@var{rcond} =} __disna__ (@var{job}, @var{d}, @var{m}, @var{n})\n\
Undocumented internal function.\n\
@end deftypefn")
{
  /*
    Interface to DDISNA and SDISNA of LAPACK.

    If job is 'E', no third or fourth argument are given. If job is 'L'
    or 'R', M and N are given.
  */

  std::string fname ("__disna__");

  octave_value retval;

  if (args.length () != 2 && args.length () != 4)
    {
      print_usage ();
      return retval;
    }

  std::string job_str;
  CHECK_ERROR (job_str = args(0).string_value (), retval,
               "%s: job label no string", fname.c_str ());

  char job;

  if (job_str.length () != 1)
    {
      error ("%s: invalid job label", fname.c_str ());
      return retval;
    }
  else
    job = job_str[0];

  F77_INT m, n, l;
  bool single;
  octave_value d;

  if (args(1).is_single_type ())
    {
      single = true;
      CHECK_ERROR (d = args(1).float_column_vector_value (), retval,
                   "s: invalid arguments", fname.c_str ());
    }
  else
    {
      single = false;
      CHECK_ERROR (d = args(1).column_vector_value (), retval,
                   "s: invalid arguments", fname.c_str ());
    }

  l = d.length ();
  switch (job)
    {
    case 'E' :
      if (args.length () != 2)
        {
          error ("%s: with job label 'E' only two arguments are allowed",
                 fname.c_str ());
          return retval;
        }
      else
        m = l;
      break;
    case 'L' :
    case 'R' :
      if (args.length () != 4)
        {
          error ("%s: with job labels 'L' or 'R', four arguments must be given",
                 fname.c_str ());
          return retval;
        }
      else
        {
          CHECK_ERROR (m = TO_F77_INT (args(2).idx_type_value ()), retval,
                       "%s: could not convert 3rd argumet to index",
                       fname.c_str ());
          CHECK_ERROR (n = TO_F77_INT (args(3).idx_type_value ()), retval,
                       "%s: could not convert 4th argumet to index",
                       fname.c_str ());
          F77_INT md = m < n ? m : n;
          if (l != md)
            {
              error ("%s: given dimensions don't match length of second argument",
                     fname.c_str ());
              return retval;
            }
        }
      break;
    default :
      error ("%s: job label not correct", fname.c_str ());
      return retval;
    }

  F77_INT info;

  if (single)
    {
      FloatColumnVector srcond (l);

      F77_XFCN (sdisna, SDISNA, (F77_CONST_CHAR_ARG2 (&job, 1),
                                 m, n,
                                 d.float_column_vector_value ().fortran_vec (),
                                 srcond.fortran_vec (),
                                 info));

      retval = srcond;
    }
  else
    {
      ColumnVector drcond (l);

      F77_XFCN (ddisna, DDISNA, (F77_CONST_CHAR_ARG2 (&job, 1),
                                 m, n,
                                 d.column_vector_value ().fortran_vec (),
                                 drcond.fortran_vec (),
                                 info));

      retval = drcond;
    }

  if (info < 0)
    error ("%s: LAPACK routine says %i-th argument had an illegal value",
           fname.c_str (), -info);

  return retval;
}
