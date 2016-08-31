#include <Rcpp.h>
#include <cstdlib>
#include <iostream>
#include <math.h>
#include "helpfunc.h"

//' Transformation of numeric matrices from long to wide format
//'
//' Transforms a set of two independent and one dependent variables in vectors from a long
//' to a wide format and exports this result as a list
//'
//' @param x vector of first independent variable. e.g. vector with x-axis spatial points
//' @param y vector of second independent variable. e.g. vector with y-axis spatial points
//' @param z vector of dependent variable. e.g. vector with z-axis spatial points
//' @param digits integer indicating the number of decimal places to be used for rounding
//' the dependent variables \code{x} and \code{y}.
//'
//' @return List with three elements:
//'
//' $x: vector with ascendingly sorted, unique values of the first independent variable \code{x}
//'
//' $y: vector with ascendingly sorted, unique values of the second independent variable \code{y}
//'
//' $z: matrix with the values of z for the defined combinations of \code{x} (columns) and
//' \code{y} (rows)
//'
//' @family transfuncs
//'
//' @examples
//' x <- c(1, 1, 1, 2, 2, 2, 3, 3, 4)
//' y <- c(1, 2, 3, 1, 2, 3, 1, 2, 3)
//' z <- c(3, 4, 2, 3, NA, 5, 6, 3, 1)
//'
//' spatialwide(x, y, z, digits = 3)
//'
//' @export
// [[Rcpp::export]]
List spatialwide(NumericVector x , NumericVector y , NumericVector z, int digits) {

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