/*
 Produced with: tools::package_native_routine_registration_skeleton(".")
*/

#include <R.h>
#include <Rinternals.h>
#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* FIXME:
Check these declarations against the C/Fortran source code.
*/

/* .Call calls */
extern SEXP _recexcavAAR_draw_circle(SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP _recexcavAAR_draw_sphere(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP _recexcavAAR_fillhexa(SEXP, SEXP);
extern SEXP _recexcavAAR_pnp(SEXP, SEXP, SEXP, SEXP);
extern SEXP _recexcavAAR_pnpmulti(SEXP, SEXP, SEXP, SEXP);
extern SEXP _recexcavAAR_posdec(SEXP, SEXP);
extern SEXP _recexcavAAR_posdeclist(SEXP, SEXP);
extern SEXP _recexcavAAR_rescale(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP _recexcavAAR_rotate(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP _recexcavAAR_spatiallong(SEXP, SEXP, SEXP);
extern SEXP _recexcavAAR_spatialwide(SEXP, SEXP, SEXP, SEXP);
extern SEXP _recexcavAAR_spitcenter(SEXP);
extern SEXP _recexcavAAR_spitcenternat(SEXP, SEXP);
extern SEXP _recexcavAAR_spitcenternatlist(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"_recexcavAAR_draw_circle",       (DL_FUNC) &_recexcavAAR_draw_circle,       5},
  {"_recexcavAAR_draw_sphere",       (DL_FUNC) &_recexcavAAR_draw_sphere,       6},
  {"_recexcavAAR_fillhexa",          (DL_FUNC) &_recexcavAAR_fillhexa,          2},
  {"_recexcavAAR_pnp",               (DL_FUNC) &_recexcavAAR_pnp,               4},
  {"_recexcavAAR_pnpmulti",          (DL_FUNC) &_recexcavAAR_pnpmulti,          4},
  {"_recexcavAAR_posdec",            (DL_FUNC) &_recexcavAAR_posdec,            2},
  {"_recexcavAAR_posdeclist",        (DL_FUNC) &_recexcavAAR_posdeclist,        2},
  {"_recexcavAAR_rescale",           (DL_FUNC) &_recexcavAAR_rescale,           6},
  {"_recexcavAAR_rotate",            (DL_FUNC) &_recexcavAAR_rotate,            9},
  {"_recexcavAAR_spatiallong",       (DL_FUNC) &_recexcavAAR_spatiallong,       3},
  {"_recexcavAAR_spatialwide",       (DL_FUNC) &_recexcavAAR_spatialwide,       4},
  {"_recexcavAAR_spitcenter",        (DL_FUNC) &_recexcavAAR_spitcenter,        1},
  {"_recexcavAAR_spitcenternat",     (DL_FUNC) &_recexcavAAR_spitcenternat,     2},
  {"_recexcavAAR_spitcenternatlist", (DL_FUNC) &_recexcavAAR_spitcenternatlist, 2},
  {NULL, NULL, 0}
};

void R_init_recexcavAAR(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}