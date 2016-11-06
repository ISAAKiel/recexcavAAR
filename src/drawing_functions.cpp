#define _USE_MATH_DEFINES

#include <Rcpp.h>
#include <math.h>

using namespace Rcpp;

//' test
//'
//' @description
//' test
//'
//' @param centerx
//' @param centery
//' @param centerz
//' @param radius
//' @param resolution
//'
//' @return test
//'
//' @examples
//'
//' @export
// [[Rcpp::export]]
DataFrame draw_circle(float centerx, float centery, float centerz, float radius, int resolution) {

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

//' test
//'
//' @description
//' test
//'
//' @param x
//' @param y
//' @param z
//' @param pivotx
//' @param pivoty
//' @param pivotz
//' @param degrx
//' @param degry
//' @param degrz
//'
//' @return test
//'
//' @examples
//'
//' @export
// [[Rcpp::export]]
DataFrame rotate(NumericVector x, NumericVector y, NumericVector z,
                 float pivotx, float pivoty, float pivotz,
                 float degrx, float degry, float degrz)  {

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

//' test
//'
//' @description
//' test
//'
//' @param centerx
//' @param centery
//' @param centerz
//' @param r
//' @param phires
//' @param thetares
//'
//' @return test
//'
//' @examples
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