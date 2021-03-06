% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{draw_sphere}
\alias{draw_sphere}
\title{Draws a spherical point cloud (3D)}
\usage{
draw_sphere(centerx, centery, centerz, radius, phires = 10L,
  thetares = 10L)
}
\arguments{
\item{centerx}{x axis value of sphere center point}

\item{centery}{y axis value of sphere center point}

\item{centerz}{z axis value of sphere center point}

\item{radius}{sphere radius}

\item{phires}{phi resolution (default = 10)}

\item{thetares}{theta resolution (default = 10)}
}
\value{
data.frame with the spatial coordinates of the resulting points
}
\description{
Draws a sphere around a center point in 3D space.
}
\examples{
sphere <- draw_sphere(
  centerx = 4,
  centery = 5,
  centerz = 1,
  radius = 3,
  phires = 20,
  thetares = 20
)

#library(rgl)
#plot3d(sphere)

}
