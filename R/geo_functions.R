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
#' surfacelist <- kriglist(lpoints, lags = 3, model = "spherical")
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