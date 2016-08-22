#include <Rcpp.h>
#include <cstdlib>
#include <iostream>
#include <math.h>
#include "helpfunc.h"

//' spatialwide2
//'
//' \code{spatialwide2} test
//'
//' @param x test
//' @param y test
//' @param z test
//' @param digits test
//'
//' @return test
//'
//' @export
// [[Rcpp::export]]
List spatialwide2(NumericVector x , NumericVector y , NumericVector z, int digits) {

  // write input vectors to NumericMatrix
  NumericMatrix longdf(z.size(), 3);
  longdf(_, 0) = x;
  longdf(_, 1) = y;
  longdf(_, 2) = z;

  // define result vectors and matrix
  NumericVector xu = stl_sort(unique(x));
  NumericVector yu = stl_sort(unique(y));
  NumericMatrix widedf = na_matrix(yu.size(), xu.size());

  // loop to fill wide matrix
  for (int p1 = 0; p1 < xu.size(); p1++) {
    for (int p2 = 0; p2 < yu.size(); p2++) {
      for (int p3 = 0; p3 < longdf.nrow(); p3++) {
        if (longdf(p3, 0) == xu[p1]) {
          if (longdf(p3, 1) == yu[p2]) {
            widedf(p2, p1) = longdf(p3, 2);
          }
        }
      }
    }
  }

  // prepare output list
  List res;
  res["x"] = round(xu, digits);
  res["y"] = round(yu, digits);
  res["z"] = widedf;

  return res;
}