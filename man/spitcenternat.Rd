% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{spitcenternat}
\alias{spitcenternat}
\title{Center determination for rectangles whose tops and bottoms are defined by irregular surfaces (3D)}
\usage{
spitcenternat(hex, maplist)
}
\arguments{
\item{hex}{data.frame with the 2D corners of the rectangle defined by four points}

\item{maplist}{list of data.frames which contain the points that make up the surfaces}
}
\value{
data.frame with the spatial coordinates of the center points
}
\description{
\code{spitcenternat} first of all calculates the horizontal center of an input rectangle.
Then it determines the vertical positions of the center points in relation to a surface stack.
}
\examples{
df1 <- data.frame(
  x = c(rep(0, 6), seq(0.2, 2.8, 0.2), seq(0.2, 2.8, 0.2), rep(3,6)),
  y = c(seq(0, 1, 0.2), rep(0, 14), rep(1, 14), seq(0, 1, 0.2)),
  z = c(0.9+0.05*rnorm(6), 0.9+0.05*rnorm(14), 1.3+0.05*rnorm(14), 1.2+0.05*rnorm(6))
)

df2 <- data.frame(
    x = c(rep(0, 6), seq(0.2, 2.8, 0.2), seq(0.2, 2.8, 0.2), rep(3,6)),
    y = c(seq(0, 1, 0.2), rep(0, 14), rep(1, 14), seq(0, 1, 0.2)),
    z = c(0.6+0.05*rnorm(6), 0.6+0.05*rnorm(14), 1.0+0.05*rnorm(14), 0.9+0.05*rnorm(6))
)

df3 <- data.frame(
    x = c(rep(0, 6), seq(0.2, 2.8, 0.2), seq(0.2, 2.8, 0.2), rep(3,6)),
    y = c(seq(0, 1, 0.2), rep(0, 14), rep(1, 14), seq(0, 1, 0.2)),
    z = c(0.3+0.05*rnorm(6), 0.3+0.05*rnorm(14), 0.7+0.05*rnorm(14), 0.6+0.05*rnorm(6))
)

lpoints <- list(df1, df2, df3)

maps <- kriglist(lpoints, lags = 3, model = "spherical")

hexatestdf <- data.frame(
    x = c(1, 1, 1, 1, 2, 2, 2, 2),
    y = c(0, 1, 0, 1, 0, 1, 0, 1)
)

spitcenternat(hexatestdf, maps)

}
\seealso{
Other centerdetfuncs: \code{\link{spitcenternatlist}},
  \code{\link{spitcenter}}
}
\concept{centerdetfuncs}
