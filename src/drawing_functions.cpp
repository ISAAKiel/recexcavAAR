#define _USE_MATH_DEFINES

#include <Rcpp.h>
#include <math.h>

using namespace Rcpp;

//' Draws a circular point cloud (3D)
//'
//' @description
//' Draws a 2D circle on x- and y-plane around a center point in 3D space.
//'
//' @param centerx x axis value of circle center point
//' @param centery y axis value of circle center point
//' @param centerz z axis value of circle center point
//' @param radius circle radius
//' @param resolution amount of circle points (default = 30)
//'
//' @return
//' data.frame with the spatial coordinates of the resulting points
//'
//' @examples
//' draw_circle(
//'   centerx = 4,
//'   centery = 5,
//'   centerz = 1,
//'   radius = 3,
//'   resolution = 20
//' )
//'
//' circ <- draw_circle(1,2,3,2)
//'
//' plot(circ$x, circ$y)
//'
//' @export
// [[Rcpp::export]]
DataFrame draw_circle(float centerx, float centery, float centerz, float radius, int resolution = 30) {

  int pnum = resolution;
  double rotation = 2 * M_PI / pnum;
  NumericMatrix res(pnum, 3);

  for (int p1 = 0; p1 < pnum; p1++) {
    double rot = p1 * rotation;
    res(p1, 0) = centerx + cos(rot) * radius;
    res(p1, 1) = centery + sin(rot) * radius;
    res(p1, 2) = centerz;
  }

  // output
  return DataFrame::create(_["x"] = res(_,0), _["y"] = res(_,1), _["z"] = res(_,2));
}

//' Rotate a point cloud around a pivot point (3D)
//'
//' @description
//' Rotate a point cloud around a defined pivot point by defined angles. The default
//' rotation angle around each axis is zero and the default pivot point is the center
//' point of the point cloud (defined by mean())
//'
//' @param x vector of x axis values of rotation point cloud
//' @param y vector of y axis values of rotation point cloud
//' @param z vector of z axis values of rotation point cloud
//' @param degrx rotation angle around x axis in degree (default = 0)
//' @param degry rotation angle around y axis in degree (default = 0)
//' @param degrz rotation angle around z axis in degree (default = 0)
//' @param pivotx x axis value of pivot point (default = mean(x))
//' @param pivoty y axis value of pivot point (default = mean(y))
//' @param pivotz z axis value of pivot point (default = mean(z))
//'
//' @return
//' data.frame with the spatial coordinates of the resulting points
//'
//' @examples
//' circ <- draw_circle(1,2,3,4)
//'
//' plot(circ$x, circ$y)
//'
//' rotcirc <- rotate(circ$x, circ$y, circ$z, degrx = 45)
//'
//' plot(rotcirc$x, rotcirc$y)
//'
//' @export
// [[Rcpp::export]]
DataFrame rotate(NumericVector x, NumericVector y, NumericVector z,
                 float degrx = 0.0, float degry = 0.0, float degrz = 0.0,
                 float pivotx = NA_REAL, float pivoty = NA_REAL, float pivotz = NA_REAL)  {

  // check for pivot point values
  // (ugly hack to use is_na)
  NumericVector pivot =  NumericVector::create(pivotx, pivoty, pivotz);
  if (NumericVector::is_na(pivot(0))) { pivotx = mean(x); }
  if (NumericVector::is_na(pivot(1))) { pivoty = mean(y); }
  if (NumericVector::is_na(pivot(2))) { pivotz = mean(z); }

  int num = x.length();

  float radx = (degrx*M_PI)/180;
  float rady = (degry*M_PI)/180;
  float radz = (degrz*M_PI)/180;

  NumericMatrix res(num, 3);

  for (int p1 = 0; p1 < num; p1++) {

    // move
    float xi = x(p1) - pivotx;
    float yi = y(p1) - pivoty;
    float zi = z(p1) - pivotz;

    // rotation along z
    float xii = xi * cos(radz) - yi * sin(radz);
    float yii = xi * sin(radz) + yi * cos(radz);
    float zii = zi;

    // rotation along y
    float xiii = xii * cos(rady) - zii * sin(rady);
    float yiii = yii;
    float ziii = zii * sin(rady) + xii * cos(radz);

    // rotation along x
    float xiiii = xiii;
    float yiiii = yiii * cos(radx) - ziii * sin(radx);
    float ziiii = ziii * sin(radx) + yiii * cos(radx);

    res(p1, 0) = xiiii + pivotx;
    res(p1, 1) = yiiii + pivoty;
    res(p1, 2) = ziiii + pivotz;

  }

  // output
  return DataFrame::create(_["x"] = res(_,0), _["y"] = res(_,1), _["z"] = res(_,2));
}

//' draw_sphere
//'
//' @description
//' test
//'
//' @param centerx test
//' @param centery test
//' @param centerz test
//' @param r test
//' @param phires test
//' @param thetares test
//'
//' @return test
//'
//' @examples
//' s <- draw_sphere(1,1,1,3)
//'
//' #library(rgl)
//' #plot3d(s)
//'
//' @export
// [[Rcpp::export]]
DataFrame draw_sphere(float centerx, float centery, float centerz,
                      float r, int phires = 10, int thetares = 10)  {

  double phir = (double) phires;
  double thetar = (double) thetares;

  std::vector<float> x;
  std::vector<float> y;
  std::vector<float> z;

  // Iterate through phi and theta
  for (double phi = 0.; phi < 2 * M_PI; phi += M_PI / phir) { // Azimuth [0, 2M_PI]
    for (double theta = 0.; theta < M_PI; theta += M_PI / thetar) { // Elevation [0, M_PI]

      x.push_back(r * cos(phi) * sin(theta) + centerx);
      y.push_back(r * sin(phi) * sin(theta) + centery);
      z.push_back(r * cos(theta) + centerz);

    }
  }

  // output
  return DataFrame::create(_["x"] = wrap(x), _["y"] = wrap(y), _["z"] = wrap(z));
}

//' scale
//'
//' @description
//' test
//'
//' @param x test
//' @param y test
//' @param z test
//' @param scalex test
//' @param scaley test
//' @param scalez test
//'
//' @return test
//'
//' @examples
//' s <- draw_sphere(1,1,1,3)
//'
//' #library(rgl)
//' #plot3d(s)
//'
//' s2 <- scale(s$x, s$y, s$z, scalex = 4, scalez = 5)
//'
//' #library(rgl)
//' #plot3d(s2)
//'
//' @export
// [[Rcpp::export]]
DataFrame scale(NumericVector x, NumericVector y, NumericVector z,
                float scalex = 1, float scaley = 1, float scalez = 1) {

  NumericMatrix res(x.size(), 3);

  res(_, 0) = x * scalex;
  res(_, 1) = y * scaley;
  res(_, 2) = z * scalez;

  // output
  return DataFrame::create(_["x"] = res(_, 0), _["y"] = res(_, 1), _["z"] = res(_ ,2));
}