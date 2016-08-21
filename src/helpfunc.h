// small helping funtions to be used in the c++ code

#include <Rcpp.h>
#include <math.h>
using namespace Rcpp;


#ifndef __UTILITIES__
#define __UTILITIES__


//' find maximum of a NumericVector
//'
//' @param x NumericVector of interest
//'
//' @return value of highest value in NumericVector.

inline double maxv(NumericVector x){
  // changing vars
  double maxi = x(0);
  // search loop
  for (int p = 0; p < x.size(); p++) {
    if (x(p) >= maxi) {
      maxi = x(p);
    }
  }
  // output
  return maxi;
}

//' find id of maximum of a NumericVector
//'
//' @param x NumericVector of interest
//'
//' @return id of highest value in NumericVector.

inline int maxid(NumericVector x){
  // changing vars
  double maxi = x(0);
  int id = 0;
  // search loop
  for (int p = 0; p < x.size(); p++) {
    if (x(p) >= maxi) {
      maxi = x(p);
      id = p;
    }
  }
  // output
  return id;
}

//' find minimum of a NumericVector
//'
//' @param x NumericVector of interest
//'
//' @return value of smallest value in NumericVector.

inline double minv(NumericVector x){
  // changing vars
  double mini = x(0);
  // search loop
  for (int p = 0; p < x.size(); p++) {
    if (x(p) <= mini) {
      mini = x(p);
    }
  }
  // output
  return mini;
}

//' find id of maximum of a NumericVector
//'
//' @param x NumericVector of interest
//'
//' @return id of highest value in NumericVector.

inline int minid(NumericVector x){
  // changing vars
  double mini = x(0);
  int id = 0;
  // search loop
  for (int p = 0; p < x.size(); p++) {
    if (x(p) <= mini) {
      mini = x(p);
      id = p;
    }
  }
  // output
  return id;
}

//' 2D distance pythagoras between two points
//'
//' @param x1
//' @param x2
//' @param y1
//' @param y2
//'
//' @return distance

inline double pyth (double x1, double y1, double x2, double y2) {
  double x = x1 - x2;
  double y = y1 - y2;
  double dist = pow(x, 2) + pow(y, 2);
  dist = sqrt(dist);
  return dist;
}


#endif //__UTILITIES__