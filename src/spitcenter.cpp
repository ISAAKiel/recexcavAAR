#include <Rcpp.h>
#include <cstdlib>
#include <iostream>
#include <math.h>
#include "helpfunc.h"

using namespace Rcpp;

//' center determination for hexahedrons
//'
//' \code{spitcenter} determines a center point for an input hexahedron
//'
//' @param hex dataframe with three columns and eight rows to define a hexahedron by its corner
//' point coordinates
//'
//' @return numeric vector with the spatial coordinates of the center point of the input hexahedron
//'
//' @examples
//' hexatestdf <- data.frame(
//'   x = c(0,1,0,4,5,5,5,5),
//'   y = c(1,1,4,4,1,1,4,4),
//'   z = c(4,8,4,9,4,8,4,6)
//' )
//'
//' center <- spitcenter(hexatestdf)
//'
//' #library(rgl)
//' #plot3d(
//' # hexatestdf$x, hexatestdf$y, hexatestdf$z,
//' # type = "p",
//' # xlab = "x", ylab = "y", zlab = "z"
//' #)
//' #plot3d(
//' #  center[1], center[2], center[3],
//' #  type = "p",
//' #  col = "red",
//' #  add = TRUE
//' #)
//'
//' @export
// [[Rcpp::export]]
NumericVector spitcenter(DataFrame hex){

  Function asMatrix("as.matrix");

  SEXP hex2mid = hex;
  NumericMatrix hexa = asMatrix(hex2mid);

  NumericVector geometriccenter = NumericVector::create(
    _["x"] = mean(hexa(_, 0)),
    _["y"] =mean(hexa(_, 1)),
    _["z"] =mean(hexa(_, 2))
  );

  return geometriccenter;
}