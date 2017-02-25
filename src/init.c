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
extern SEXP recexcavAAR_draw_circle(SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP recexcavAAR_draw_sphere(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP recexcavAAR_fillhexa(SEXP, SEXP);
extern SEXP recexcavAAR_pnp(SEXP, SEXP, SEXP, SEXP);
extern SEXP recexcavAAR_pnpmulti(SEXP, SEXP, SEXP, SEXP);
extern SEXP recexcavAAR_posdec(SEXP, SEXP);
extern SEXP recexcavAAR_posdeclist(SEXP, SEXP);
extern SEXP recexcavAAR_rescale(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP recexcavAAR_rotate(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
extern SEXP recexcavAAR_spatiallong(SEXP, SEXP, SEXP);
extern SEXP recexcavAAR_spatialwide(SEXP, SEXP, SEXP, SEXP);
extern SEXP recexcavAAR_spitcenter(SEXP);
extern SEXP recexcavAAR_spitcenternat(SEXP, SEXP);
extern SEXP recexcavAAR_spitcenternatlist(SEXP, SEXP);

static const R_CallMethodDef CallEntries[] = {
  {"recexcavAAR_draw_circle",       (DL_FUNC) &recexcavAAR_draw_circle,       5},
  {"recexcavAAR_draw_sphere",       (DL_FUNC) &recexcavAAR_draw_sphere,       6},
  {"recexcavAAR_fillhexa",          (DL_FUNC) &recexcavAAR_fillhexa,          2},
  {"recexcavAAR_pnp",               (DL_FUNC) &recexcavAAR_pnp,               4},
  {"recexcavAAR_pnpmulti",          (DL_FUNC) &recexcavAAR_pnpmulti,          4},
  {"recexcavAAR_posdec",            (DL_FUNC) &recexcavAAR_posdec,            2},
  {"recexcavAAR_posdeclist",        (DL_FUNC) &recexcavAAR_posdeclist,        2},
  {"recexcavAAR_rescale",           (DL_FUNC) &recexcavAAR_rescale,           6},
  {"recexcavAAR_rotate",            (DL_FUNC) &recexcavAAR_rotate,            9},
  {"recexcavAAR_spatiallong",       (DL_FUNC) &recexcavAAR_spatiallong,       3},
  {"recexcavAAR_spatialwide",       (DL_FUNC) &recexcavAAR_spatialwide,       4},
  {"recexcavAAR_spitcenter",        (DL_FUNC) &recexcavAAR_spitcenter,        1},
  {"recexcavAAR_spitcenternat",     (DL_FUNC) &recexcavAAR_spitcenternat,     2},
  {"recexcavAAR_spitcenternatlist", (DL_FUNC) &recexcavAAR_spitcenternatlist, 2},
  {NULL, NULL, 0}
};

void R_init_recexcavAAR(DllInfo *dll)
{
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}