#' KT_data: Niveau measurements from the fictional trench of a excavation KT
#'
#' A dataset containing coordinates of niveau measurements of a fictional excavation KT with
#' 4 spits.
#'
#' @format A data frame with 304 rows and 4 variables:
#' \itemize{
#'   \item id: IDs of individual measurements with the information about to which level
#'   they belong
#'   \item x: x axis coordinates of measurements
#'   \item y: y axis coordinates of measurements
#'   \item z: z axis coordinates of measurements
#' }
#'
#' @family KT_data
#'
#' @name KT_spits
NULL

#' KT_data: Corner points of a 1m*1m raster within the trench of a fictional excavation KT
#'
#' A dataset containing horizontal coordinates of corner points of a 1m*1m raster within
#' the rectangular trench (corner points of squares).
#'
#' @format A data frame with 63 rows and 2 variables:
#' \itemize{
#'   \item x: x axis coordinates of corner points
#'   \item y: y axis coordinates of corner points
#' }
#'
#' @family KT_data
#'
#' @name KT_squarecorners
NULL

#' KT_data: Information about individual sherds of a reconstructed vessel from the trench
#' of a fictional excavation KT
#'
#' A dataset containing spatial and contextual information for individual sherds of a single
#' vessel. Some sherds were documented in the field with single find measurements. For the
#' others only spit and square attribution is possible.
#'
#' @format A data frame with 7 rows and 7 variables:
#' \itemize{
#'   \item inv: Inventory numbers of sherds. KTF means single find with individual measurement,
#'   KTM means mass find without this precise information.
#'   \item spit: spits where the sherds were found
#'   \item square: squares where the sherds were found
#'   \item feature: features where the sherds were found
#'   \item x: x axis coordinates of sherds
#'   \item y: y axis coordinates of sherds
#'   \item z: z axis coordinates of sherds
#' }
#'
#' @family KT_data
#'
#' @name KT_vessel
NULL

#' fotogram_pts: Fictional fotogrammetrie control points
#'
#' A dataset containing four profiles with fotogrammetrie control points
#'
#' @format A SpatialDataFrame:
#' \itemize{
#'   \item pr: The profile number, respectively the grouping variable
#'   \item ansicht: The direction of view

#' }
#'
#'
#' @name fotogram_pts
NULL