% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{spatialwide}
\alias{spatialwide}
\title{Transformation of numeric matrices from long to wide format}
\usage{
spatialwide(x, y, z, digits)
}
\arguments{
\item{x}{vector of first independent variable. e.g. vector with x-axis spatial points}

\item{y}{vector of second independent variable. e.g. vector with y-axis spatial points}

\item{z}{vector of dependent variable. e.g. vector with z-axis spatial points}

\item{digits}{integer indicating the number of decimal places to be used for rounding
the dependent variables \code{x} and \code{y}.}
}
\value{
List with three elements:

$x: vector with ascendingly sorted, unique values of the first independent variable \code{x}

$y: vector with ascendingly sorted, unique values of the second independent variable \code{y}

$z: matrix with the values of z for the defined combinations of \code{x} (columns) and
\code{y} (rows)
}
\description{
Transforms a set of two independent and one dependent variables in vectors from a long
to a wide format and exports this result as a list
}
\examples{
x <- c(1, 1, 1, 2, 2, 2, 3, 3, 4)
y <- c(1, 2, 3, 1, 2, 3, 1, 2, 3)
z <- c(3, 4, 2, 3, NA, 5, 6, 3, 1)

spatialwide(x, y, z, digits = 3)

}
\seealso{
Other transfuncs: \code{\link{spatiallong}}
}
\concept{transfuncs}
