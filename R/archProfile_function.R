#' Tool for rotating profile control points for rectifiying images
#'
#' @param fotogram_pts SpatialPointsDataFrame or Dataframe. A sp::SpatialPointsDataFrame or dataframe containing the control points (3 Dimensions).
#' @param profile_col character. Name of the column containing the profile group variable (profile number).
#' @param view_col character. Name of the profile containing the viewing direction ("N","S","W","E").
#' @param view character. Direction of view on the Profile.
#' @param x character. (optional) If input is a dataframe, column with x coordinates.
#' @param y character. (optional) If input is a dataframe, column with y coordinates.
#' @param z character. (optional) If input is a dataframe, column with z coordinates.
#' \itemize{
#'   \item{"projected"}{: (default) on a vertial intersecting pane like a drawing}
#'   \item{"surface"}{: orthogonal to the surface of the profile}
#' }
#' @param direction character. Position of the profile control points.
#' \itemize{
#'   \item{"horizontal"}{: (default) profile is horizontal, the relative heigth is still correct, good for catalogue export}
#'   \item{"original"}{:  the points are on the profile section}
#' }
#' @return sp::SpatialPointsDataFrame with the new coordinates.
#'
#' @examples
#' fotogram_sdf <- sp::SpatialPointsDataFrame(
#'   coords = fotogram_pts[, c(1,2,3)],
#'   data = fotogram_pts,
#'   proj4string = sp::CRS("+proj=utm +zone=32 +ellps=GRS80 +units=m +no_defs")
#' )
#'
#' profile <- archprofile(
#'   fotogram_pts = fotogram_sdf,
#'   profile_col = "pr",
#'   view_col = "view"
#' )
#'
#' @export
archprofile <- function(fotogram_pts, profile_col, view_col, x, y, z,
                        view = "projected",  direction = "horizontal") {
  #The file needs two more colums, one for the grouping of the profile
  #(e.g. profilenumber), and a
  #column with the point of view (view from N/S/E/W) for the rotating direction


  #All points need to be rotated around the profile's centre,
  #therefore they are parallel to the x axis
  #All points need to be (theortical) on a plane
  #At first writing the coordinates and attributes in a dataframe
#If input is a spatialdataframe
  if(typeof(fotogram_pts)=="S4"){
    coord <- data.frame(
    x = fotogram_pts@coords[, 1],
    y = fotogram_pts@coords[, 2],
    z = fotogram_pts@coords[, 3],
    pr = fotogram_pts@data[, profile_col],
    view = fotogram_pts@data[, view_col]
  )
  }
# If input is a dataframe
  if(typeof(fotogram_pts)=="list"){
      coord <- data.frame(
      x = fotogram_pts[,x],
      y = fotogram_pts[, y],
      z = fotogram_pts[, z],
      pr = fotogram_pts[, profile_col],
      view = fotogram_pts[, view_col]
    )
  }



  #Now starting with each profile individual
  #possible nas has to be omitted
  coord <- na.omit(coord)
  #Getting all names of the profiles, to use the amount
  #for the n of iterations of the loop
  prnames <- levels(as.factor(coord$pr))
  #A dataframe with the same length as the import is needed for the export ,
  #A copy of the import df is used. All colums have 0 values for seeing errors

  coord_export <- coord
  coord_export$view <- NULL
  coord_export$pr <- 0
  coord_export$x <- 0
  coord_export$y <- 0
  coord_export$z <- 0
  i <- 1
  #Now going for every profile
  while (i <= length(prnames)) {

    #Writing all data of the actual profile in a teporary dataframe
    coord_proc <- coord[which(coord$pr == prnames[i]),]

    #A linear regression is used to get the gradient of the profile,
    #the regression balances the askew profile
    #######Error -> It seems as if the slope of the regression is na if a profile is nearly N-S oriented

    #First step is to rotate the profile control points around z-axis
    #therefore the angle of the profile to the x axis is necessary
    yw <- c(coord_proc$y) - min(coord_proc$y)
    xw <- c(coord_proc$x) - min(coord_proc$x)
    fm <- lm(yw ~ xw)

    #extrakte the solpe of the profile
    slope <- coef(fm)[2]

    #Now we have to take care if the profile needs to be rotade clock or counterclockwise

    #This is determined by two factors the slope and the direction of view
    #The view is defined by the position of the observer (view from east)
    #There are four cases (+ special case m = 0)
    #1. m = - view = N/E -> clockwise
    #2. m = - view = S/W -> counterclockwise
    #3. m = + view = S/E -> clockwise
    #4. m = + view = N/W -> counterclockwise
    #Find Rotationangle for this cases (rad -> deg)

    ################
    #Critical code start
    ################
    view_proc <- coord_proc$view[1]

    if (slope < 0 && view_proc %in% c("N", "E")) {
      slope_deg <- 180 - abs((atan(slope) * 180) / pi) * -1
    } else if (slope < 0 && view_proc %in% c("S", "W")) {
      slope_deg <- abs((atan(slope) * 180) / pi)
    } else if (slope > 0 && view_proc %in% c("S", "E")) {
      slope_deg <- ((atan(slope) * 180) / pi) * -1
    } else if (slope > 0 && view_proc %in% c("N", "W")) {
      slope_deg <- 180 - ((atan(slope) * 180) / pi)
    } else if (slope == 0 && view_proc == "N") {
      slope_deg <- 180
    } else if (slope == 0 && view_proc == "N") {
      slope_deg <- 0
    }
    ################
    #Critical code end
    ################
    #Next step is to find the rotation point
    #This is in the middle of the profile
    center_x <- sum(coord_proc$x) / nrow(coord_proc)
    center_y <- sum(coord_proc$y) / nrow(coord_proc)

    #Rotate around the point and use a temp dataframe
    coord_trans <- coord_proc
    #df without the view column
    coord_trans$view <- NULL

    ################
    #Critical code start
    ################
    #We use translation and rotation to find the new points
    #The mean y-Value will be added to the z-Value, therefore the control points are on the profile in the end
    for (z in 1:nrow(coord_proc)) {
      coord_trans[z,] <- c(
        center_x + (coord_proc$x[z] - center_x) *
          cos(slope_deg / 180 * pi) - sin(slope_deg / 180 * pi) *
          (coord_proc$y[z] - center_y),
        center_y + (coord_proc$x[z] - center_x) *
          sin(slope_deg / 180 * pi) + (coord_proc$y[z] - center_y) *
          cos(slope_deg / 180 * pi),
        coord_proc$z[z] + center_y - mean(coord_proc$z),
        as.numeric(as.character(coord_trans$pr[z]))
      )
      ################
      #Critical code end
      ################

      #http://www.matheboard.de/archive/460078/thread.html
    }

  #If the aim is to get the view of the surface, we have to do the same with a rotation on the x-axis
    if (view == "surface") {

      z_yw <- c(coord_trans$y - min(c(coord_trans$y, coord_trans$z)))
      z_zw <- c(coord_trans$z - min(c(coord_trans$y, coord_trans$z)))
      z_fm <- lm(z_zw ~ z_yw)


      z_slope <- coef(z_fm)[2]
      ################
      #Critical code start
      ################
      if (z_slope < 0) {
        z_slope_deg <- -(90 - abs((atan(z_slope) * 180) / pi))
      } else if (z_slope > 0) {
        z_slope_deg <- 90 - ((atan(z_slope) * 180) / pi)
      } else if (z_slope == 0) {
        z_slope_deg <- 0
      }
      ################
      #Critical code end
      ################
      z_center_y <- sum(coord_trans$y) / nrow(coord_trans)
      z_center_z <- sum(coord_trans$z) / nrow(coord_trans)

      z_coord <- coord_trans
      ################
      #Critical code start
      ################
      for (z in 1:nrow(z_coord)) {
        z_coord[z,] <- c(
          coord_trans$x[z],
          z_center_y + (coord_trans$y[z] - z_center_y) * cos(z_slope_deg / 180 * pi) -
            (coord_trans$z[z] - z_center_z) * sin(z_slope_deg / 180 * pi),
          z_center_z + (coord_trans$y[z] - z_center_y) * sin(z_slope_deg / 180 * pi) +
            (coord_trans$z[z] - z_center_z) * cos(z_slope_deg / 180 * pi),
          as.numeric(as.character(coord_trans$pr[z]))
        )
        #http://www.matheboard.de/archive/460078/thread.html
      }
      ################
      #Critical code end
      ################
      coord_trans <- z_coord
    }
#If the direction is horizontal we don't have to do anything. The points are now parallel to the x-axis
#If the direction is original, we have to rotate them back to the profile cut line

    if (direction == "original") {
      y_xw <- c(coord_trans$x -  min(c(coord_trans$x, coord_trans$z)))
      y_zw <- c(coord_trans$z -  min(c(coord_trans$x, coord_trans$z)))
      y_fm <- lm(y_zw ~ y_xw)


      #the rotation angle is the neagtaive angle of the rotaion of step one
      y_slope_deg <- -slope_deg

      y_center_x <- sum(coord_trans$x) / nrow(coord_trans)
      y_center_z <- sum(coord_trans$z) / nrow(coord_trans)

      y_coord <- coord_trans

      ################
      #Critical code start
      ################
      for (z in 1:nrow(y_coord)) {
        y_coord[z,] <- c(
          y_center_x + (coord_trans$x[z] - y_center_x) * cos(y_slope_deg / 180 * pi) -
            (coord_trans$z[z] - y_center_z) * sin(y_slope_deg / 180 * pi),
          coord_trans$y[z],
          y_center_z + (coord_trans$x[z] - y_center_x) * sin(y_slope_deg / 180 * pi) +
            (coord_trans$z[z] - y_center_z) * cos(y_slope_deg / 180 * pi),
          as.numeric(as.character(coord_trans$pr[z]))
        )
        #http://www.matheboard.de/archive/460078/thread.html
      }
      ################
      #Critical code end
      ################
      coord_trans <- y_coord
    }
    #Teh result will be saved in the export dataframe
    coord_export[which(coord$pr == prnames[i]),] <- coord_trans
    coord_export[which(coord$pr == prnames[i]),]$pr <- as.numeric(as.character(coord_trans$pr))
    #next profile
    i <- i + 1
    #delete temp dataframes
    coord_proc <- NULL
    coord_trans <- NULL

    if (view == "surface") {
      z_coord <- NULL
    }

  }

  #Now we can build a spataildataframe where y = z
  #
  #If input is sdf, export sdf
  if(typeof(fotogram_pts)=="S4"){
    export <- SpatialPointsDataFrame(
      coords = coord_export[, c(1, 3)],
      data = coord_export,
      proj4string = fotogram_pts@proj4string
      )
  } else if (typeof(fotogram_pts)=="list"){
    export <- data.frame(coord_export[,1],
                     coord_export[,2],
                     coord_export[,4]
                     )

  }

  return(export)
}