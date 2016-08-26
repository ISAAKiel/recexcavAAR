#include <Rcpp.h>
#include "helpfunc.h"
using namespace Rcpp;

//' test
//'
//' @description
//' Based on this solution:
//' Copyright (c) 1970-2003, Wm. Randolph Franklin
//' \url{https://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html}
//'
//' @details
//' For discussion see: \url{http://stackoverflow.com/questions/217578/how-can-i-determine-whether-a-2d-point-is-within-a-polygon/2922778#2922778}
//'
//' @param vertx test
//' @param verty test
//' @param testx test
//' @param testy test
//'
//' @return test
//'
//' @examples
//' df <- data.frame(
//'   x = c(1,1,2,2),
//'   y = c(1,2,1,2)
//' )
//'
//' pnp(df$x, df$y, 1.5, 1.5)
//' pnp(df$x, df$y, 2.5, 2.5)
//'
//' # caution: false-negatives in edge-cases:
//' pnp(df$x, df$y, 2, 1.5)
//'
//' @export
// [[Rcpp::export]]
bool pnp(NumericVector vertx, NumericVector verty, float testx, float testy) {

  int nvert = vertx.size();
  bool c = FALSE;
  int i, j = 0;
  for (i = 0, j = nvert-1; i < nvert; j = i++) {
    if ( ((verty[i]>testy) != (verty[j]>testy)) &&
         (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
      c = !c;
  }

  return c;
}

//' test
//'
//' @description
//' test
//'
//' @param vertx test
//' @param verty test
//' @param testx test
//' @param testy test
//'
//' @return test
//'
//' @examples
//' polydf <- data.frame(
//'   x = c(1,1,2,2),
//'   y = c(1,2,1,2)
//' )
//'
//' testdf <- data.frame(
//'   x = c(1.5, 2.5),
//'   y = c(1.5, 2.5)
//' )
//'
//' pnpmulti(polydf$x, polydf$y, testdf$x, testdf$y)
//'
//' @export
// [[Rcpp::export]]
LogicalVector pnpmulti(NumericVector vertx, NumericVector verty, NumericVector testx, NumericVector testy){

  int n = testx.size();
  LogicalVector deci(n);
  for(int i = 0; i < n; i++) {
    deci(i) = pnp(vertx, verty, testx(i), testy(i));
  }

  return deci;
}