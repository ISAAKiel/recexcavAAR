#include <Rcpp.h>
#include <cstdlib>
#include <iostream>
#include <math.h>
#include "helpfunc.h"

//' Transformation of numeric matrices wide to long format
//'
//' Transforms a set of two independent variables in vectors and a dependent variable in a wide
//' matrix to a long matrix that combines the information. The result is exported as a data.frame
//'
//' @param x vector of first independent variable. e.g. vector with x-axis spatial points
//' @param y vector of second independent variable. e.g. vector with y-axis spatial points
//' @param z matrix of dependent variable. e.g. matrix with z-axis spatial points
//'
//' @return data.frame with three columns x, y and z
//'
//' @examples
//' x <- c(1, 1, 1, 2, 2, 2, 3, 3, 4)
//' y <- c(1, 2, 3, 1, 2, 3, 1, 2, 3)
//' z <- c(3, 4, 2, 3, NA, 5, 6, 3, 1)
//'
//' sw <- spatialwide(x, y, z, digits = 3)
//'
//' spatiallong(sw$x, sw$y, sw$z)
//'
//' @export
// [[Rcpp::export]]
DataFrame spatiallong(NumericVector x , NumericVector y , NumericMatrix z) {

  // count z values that are not NA to create a res matrix of correct length
  int vcount = 0;
  for (int p1 = 0; p1 < z.ncol(); p1++) {
    for (int p2 = 0; p2 < z.nrow(); p2++) {
      if (!(NumericMatrix::is_na(z(p2, p1)))) {
        vcount++;
      }
    }
  }

  // create empty result matrix
  NumericMatrix res = na_matrix(vcount, 3);

  // fill result matrix
  int countp = 0;
  for (int p1 = 0; p1 < z.ncol(); p1++) {
    for (int p2 = 0; p2 < z.nrow(); p2++) {
      if (!(NumericMatrix::is_na(z(p2, p1)))) {
        res(countp, 0) = x(p1);
        res(countp, 1) = y(p2);
        res(countp, 2) = z(p2, p1);
        countp++;
      }
    }
  }

  return DataFrame::create(_["x"] = res(_, 0), _["y"] = res(_, 1), _["z"] = res(_, 2));
}