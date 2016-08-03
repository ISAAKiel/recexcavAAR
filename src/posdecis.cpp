#include <Rcpp.h>
#include <cstdlib>
#include <iostream>
#include <math.h>
#include "helpfunc.h"

using namespace Rcpp;

//' position decision in relation to a set of stacked surfaces
//'
//' \code{posdec} has the purpose to make a decision about the position of individual points in relation
//' to a set of stacked surfaces. The decision is made by comparing the mean z-axis value of the four
//' horizontally closest points of a surface to the z-axis value of the point in question.
//'
//' @param crlist data.frame with the spatial coordinates of the points of interest
//' @param maplist list of data.frames which contain the points that make up the surfaces
//'
//' @return data.frame with the spatial coordinates of the points of interest and the respective position
//' information
//'
//' @examples
//' df1 <- data.frame(
//'   x = rnorm(50),
//'   y = rnorm(50),
//'   z = rnorm(50) - 5
//' )
//'
//' df2 <- data.frame(
//'   x = rnorm(50),
//'   y = rnorm(50),
//'   z = rnorm(50) + 5
//')
//'
//' lpoints <- list(df1, df2)
//'
//' maps <- kriglist(lpoints, lags = 3, model = "spherical")
//'
//' finds <- data.frame(
//'   x = c(0, 1, 0.5, 0.7),
//'   y = c(0.5, 0, 1, 0.7),
//'   z = c(-10, 10, 0, 2)
//' )
//'
//' posdec(finds, maps)
//'
//' @export
// [[Rcpp::export]]
DataFrame posdec(DataFrame crlist, List maplist){

  Function asMatrix("as.matrix");

  // transform input pointlist to NumericMatrix -> cube2
  SEXP cube2mid = crlist;
  NumericMatrix cube2 = asMatrix(cube2mid);
  // create result table with decision column -> cubedec
  NumericMatrix cubedec(cube2.nrow(), 4);
  // loop to deal with every layer
  for (int mp = 0; mp < maplist.size(); mp++) {
    // select matrix with points of the current layer -> curmap
    SEXP curmapmid = maplist[mp];
    NumericMatrix curmap = asMatrix(curmapmid);
    // find maxdist of current layer (puspose: see below)
    NumericVector xcl = curmap(_, 0);
    NumericVector ycl = curmap(_, 1);
    double maxdist = pyth(minv(xcl), minv(ycl), maxv(xcl), maxv(ycl));
    // create vectors for individual point distances
    // (horizontal -> mindistps and vertical -> mindistz)
    NumericVector mindistps(4);
    NumericVector mindistz(4);
    // loop to deal with every single point of interest
    for (int pcube = 0; pcube < cube2.nrow(); pcube++) {
      // get horizontal coordinates of the single point of interest -> x1, y1
      double x1 = cube2(pcube, 0);
      double y1 = cube2(pcube, 1);
      // loop to determine four points with the shortest distance by calculating distance of single point
      // to every point of the current layer
      for (int p1 = 0; p1 < curmap.nrow(); p1++) {
        // get horizontal coordinates of the single point of the layer -> x2, y2
        double x2 = curmap(p1, 0);
        double y2 = curmap(p1, 1);
        // calculate horizontal euclidian distance of single point of interest and single point of layer
        // -> dist
        double dist = pyth(x1, y1, x2, y2);
        // at the beginning: set minimum distance value for all four closest points to maxdist - this value
        // will be adjusted step by step
        if (p1 == 0) {
          mindistps(0) = maxdist;
          mindistps(1) = maxdist;
          mindistps(2) = maxdist;
          mindistps(3) = maxdist;
        }
        //debug
        // if (p1 % 100 == 0) {
        //   Rcout << "layer: " << mp << std::endl;
        //   Rcout << "0 " << mindistps(0) << std::endl;
        //   Rcout << "1 " << mindistps(1) << std::endl;
        //   Rcout << "2 " << mindistps(2) << std::endl;
        //   Rcout << "3 " << mindistps(3) << std::endl;
        //   if (mp >= 3) {
        //     Rcout << "x2 - " << x2 << std::endl;
        //     Rcout << "y2 - " << y2 << std::endl;
        //     Rcout << "dist - " << dist << std::endl;
        //   }
        // }
        // find id of biggest value in vector mindistps
        int id = maxid(mindistps);
        // if the current point of layer has a smaller distance to the current point of interest, then
        // replace the biggest value in vector mindistps by new smaller value (if so) and also store z value
        // of the current single point of layer
        if (dist <= mindistps(id)) {
          mindistps(id) = dist;
          mindistz(id) = curmap(p1, 2);
        }
      }
      // calculate mean height (-> zmap) of the four horizontally closest points of layer stored in vectors
      // mindistps and mindistz
      double ztemp = 0;
      for (int p3 = 0; p3 < mindistz.size(); p3++) {
        ztemp += mindistz(p3);
      }
      double zmap = ztemp/4.0;
      // copy coordinate values of current points from input point list to output point list
      cubedec(pcube, 0) = cube2(pcube, 0);
      cubedec(pcube, 1) = cube2(pcube, 1);
      cubedec(pcube, 2) = cube2(pcube, 2);
      //
      if (mp == 0 && cube2(pcube, 2) >= zmap) {
        cubedec(pcube, 3) = mp+1;
      } else if (mp != 0 && cube2(pcube, 2) >= zmap) {
        cubedec(pcube, 3) += 1;
      }

    //debug
    //break;

    }
  }

  // copying columns of cubedec (output list) to individual NumericVectors to be able to construct a nice
  // output data.frame
  NumericVector x = cubedec(_,0);
  NumericVector y = cubedec(_,1);
  NumericVector z = cubedec(_,2);
  NumericVector pos = cubedec(_,3);

  // construct output data.frame, then output
  return DataFrame::create(_["x"] = x, _["y"] = y, _["z"] = z, _["pos"] = pos);
}

//' position decision in relation to a set of stacked surfaces (for lists of data.frames)
//'
//' \code{posdeclist} works as \code{posdec} but not just for a single data.frame but for a list of
//' data.frames
//'
//' @param crlist list of data.frames with the spatial coordinates of the points of interest
//' @param maplist list of data.frames which contain the points that make up the surfaces
//'
//' @return list of data.frames with the spatial coordinates of the points of interest and the respective
//' position information
//'
//' @examples
//' df1 <- data.frame(
//'   x = rnorm(50),
//'   y = rnorm(50),
//'   z = rnorm(50) - 5
//' )
//'
//' df2 <- data.frame(
//'   x = rnorm(50),
//'   y = rnorm(50),
//'   z = rnorm(50) + 5
//')
//'
//' lpoints <- list(df1, df2)
//'
//' maps <- kriglist(lpoints, lags = 3, model = "spherical")
//'
//' hexadf1 <- data.frame(
//'   x = c(0, 1, 0, 4, 5, 5, 5, 5),
//'   y = c(1, 1, 4, 4, 1, 1, 4, 4),
//'   z = c(1, 5, 1, 6, 1, 5, 1, 3)
//' )
//'
//' hexadf2 <- data.frame(
//'   x = c(0, 1, 0, 4, 5, 5, 5, 5),
//'   y = c(1, 1, 4, 4, 1, 1, 4, 4),
//'   z = c(-1, -5, -1, -6, -1, -5, -1, -3)
//' )
//'
//' cx1 <- fillhexa(hexadf1, 0.1)
//' cx2 <- fillhexa(hexadf2, 0.1)
//'
//' cubelist <- list(cx1, cx2)
//'
//' posdeclist(cubelist, maps)
//'
//' @export
// [[Rcpp::export]]
List posdeclist(List crlist, List maplist){

  Function asMatrix("as.matrix");

  for (int crp = 0; crp < crlist.size(); crp++){

    SEXP cube2mid = crlist[crp];
    NumericMatrix cube2 = asMatrix(cube2mid);
    NumericMatrix cubedec(cube2.nrow(), 4);

    for (int mp = 0; mp < maplist.size(); mp++){
      SEXP curmapmid = maplist[mp];
      NumericMatrix curmap = asMatrix(curmapmid);

      NumericVector xcl = curmap(_, 0);
      NumericVector ycl = curmap(_, 1);
      double maxdist = pyth(minv(xcl), minv(ycl), maxv(xcl), maxv(ycl));

      NumericVector mindistps(4);
      NumericVector mindistz(4);

      for (int pcube = 0; pcube < cube2.nrow(); pcube++) {
        double x1 = cube2(pcube, 0);
        double y1 = cube2(pcube, 1);

        for (int p1 = 0; p1 < curmap.nrow(); p1++) {
          double x2 = curmap(p1, 0);
          double y2 = curmap(p1, 1);
          double dist = pyth(x1, y1, x2, y2);

          if (p1 == 0){
            mindistps(0) = maxdist;
            mindistps(1) = maxdist;
            mindistps(2) = maxdist;
            mindistps(3) = maxdist;
          }

          int id = maxid(mindistps);

          if (dist <= mindistps(id)) {
            mindistps(id) = dist;
            mindistz(id) = curmap(p1, 2);
          }

        }
        double ztemp = 0;
        for (int p3 = 0; p3 < mindistz.size(); p3++) {
          ztemp += mindistz(p3);
        }
        double zmap = ztemp/4.0;

        cubedec(pcube, 0) = cube2(pcube, 0);
        cubedec(pcube, 1) = cube2(pcube, 1);
        cubedec(pcube, 2) = cube2(pcube, 2);

        if (mp == 0 && cube2(pcube, 2) >= zmap) {
          cubedec(pcube, 3) = mp+1;
        } else if (mp != 0 && cube2(pcube, 2) >= zmap) {
          cubedec(pcube, 3) += 1;
        }
      }
    }
    NumericVector x = cubedec(_,0);
    NumericVector y = cubedec(_,1);
    NumericVector z = cubedec(_,2);
    NumericVector pos = cubedec(_,3);

    crlist[crp] = DataFrame::create(_["x"] = x, _["y"] = y, _["z"] = z, _["pos"] = pos);
  }

  return crlist;
}