# General roxygen tags
#' @useDynLib recexcavAAR
#' @importFrom Rcpp sourceCpp

#' @export
.onUnload <- function (libpath) {
  library.dynam.unload("recexcavAAR", libpath)
}