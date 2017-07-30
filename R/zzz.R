# General roxygen tags
#' @useDynLib recexcavAAR
#' @importFrom Rcpp sourceCpp
#' @import stats
#' @importFrom sp SpatialPointsDataFrame CRS

#' @export
.onUnload <- function (libpath) {
  library.dynam.unload("recexcavAAR", libpath)
}