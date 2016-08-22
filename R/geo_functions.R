# Begin geo modelling functions  ---------------------------

#' Apply kriging \{kriging\} to a list of data.frames
#'
#' \code{kriging} \{kriging\} is a simple and highly optimized ordinary kriging algorithm to plot
#' geographical data. This interface to the method allows to not just apply it to one data.frame but
#' to a list of data.frames. The result is reduced to the data.frame with the predicted values.
#' For a more detailed output \code{kriging} \{kriging\} has to be called for the individual input
#' data.frames.
#'
#' @param plist List of data.frames with point coordinates
#' @param x index of data.frame column with x-axis spatial points. Defaults to 1
#' @param y index of data.frame column with y-axis spatial points. Defaults to 2
#' @param z index of data.frame column with z-axis spatial points. Defaults to 3
#' @param rdup switch to activate removal of double values for single horizontal positions in the input
#' data.frames. Defaults to TRUE
#' @param ... Arguments to be passed to method \code{kriging} \{kriging\}
#'
#' @return list with data.frames which contains the predicted values along with the coordinate covariates
#'
#' @examples
#' df1 <- data.frame(
#'  x = rnorm(50),
#'  y = rnorm(50),
#'  z = rnorm(50) - 5
#' )
#'
#' df2 <- data.frame(
#'  x = rnorm(50),
#'  y = rnorm(50),
#'  z = rnorm(50) + 5
#' )
#'
#' lpoints <- list(df1, df2)
#'
#' kriglist(lpoints, lags = 3, model = "spherical")
#'
#' @import kriging
#'
#' @export
#'

kriglist <- function(plist, x = 1, y = 2, z = 3, rdup = TRUE, ...) {
  # create output list
  maplist <- list()
  # loop to do kriging for all data.frames in the input list
  for (i in 1:length(plist)) {
    # remove duplicated values (x- & y-coordinate equal)
    if (rdup) {
      plist[[i]] <- plist[[i]][!duplicated(plist[[i]][,c(x,y)]),]
    }
    # kriging
    maplist[[i]] <- kriging::kriging(
      x = plist[[i]][,x],
      y = plist[[i]][,y],
      response = plist[[i]][,z],
      ...
    )$map
  }
  return(maplist)
}

# End geo modelling functions  ---------------------------

# Begin geo data layout transformation functions  ---------------------------

#' Transformation of numeric matrices from long to wide format
#'
#' Transforms a set of two independent and one dependent variables in vectors from a long
#' to a wide format and exports this result as a data.frame
#'
#' @param x vector of first independent variable. e.g. vector with x-axis spatial points
#' @param y vector of second independent variable. e.g. vector with y-axis spatial points
#' @param z vector of dependent variable. e.g. vector with z-axis spatial points
#' @param digits integer indicating the number of decimal places to be used for rounding
#' the colnames (\code{x}) and rownames (\code{y}).
#'
#' @return data.frame in wide format
#'
#' @examples
#' x <- c(1, 1, 1, 2, 2, 2, 3, 3, 4)
#' y <- c(1, 2, 3, 1, 2, 3, 1, 2, 3)
#' z <- c(3, 4, 2, 3, NA, 5, 6, 3, 1)
#'
#' spatialwide(x, y, z)
#'
#' @export
#'

spatialwide <- function(x , y , z, digits = 3) {

  # combine input vectors to data.frame
  longdf <- data.frame(x, y, z)

  # define result matrix
  xu <- unique(longdf$x)
  yu <- unique(longdf$y)
  widedf <- matrix(NA, length(yu), length(xu))

  # loop to fill wide matrix
  for (p1 in 1:ncol(widedf)) {
    for (p2 in 1:nrow(widedf)) {
      fil <- which(longdf$x == xu[p1] & longdf$y == yu[p2])
      if (length(fil) != 0) {
        zc <- longdf$z[fil]
        widedf[p2, p1] <- zc
        longdf <- longdf[-fil,]
      }
    }
  }

  # prepare output and attribute colnames&rownames
  widedf <- data.frame(widedf)
  colnames(widedf) <- round(xu, digits)
  rownames(widedf) <- round(yu, digits)

  return(widedf)
}

# End geo data layout transformation functions  ---------------------------
