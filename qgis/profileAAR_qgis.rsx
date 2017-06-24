## fotogram_pts = vector
## profile_col = string
## view_col = string
## output = output vector


profile_id <- 1
while(profile_id<length(colnames(fotogram_pts@data)) &&
colnames(fotogram_pts@data)[profile_id] != profile_col)
{
    profile_id <- profile_id+1
}

  view_id <- 1
  while(view_id<length(colnames(fotogram_pts@data)) &&
        colnames(fotogram_pts@data)[view_id] != view_col)
  {
    view_id <- view_id+1
  }


  coord <- data.frame(fotogram_pts@coords[ ,1],
                      fotogram_pts@coords[ ,2],
                      fotogram_pts@coords[ ,3],
                      fotogram_pts@data[ ,profile_id],
                      fotogram_pts@data[, view_id])
  colnames(coord) <- c("x", "y", "z", "pr","view")


  coord <- na.omit(coord)
  prnames <- levels(as.factor(coord$pr))
  coord_export <- coord
  coord_export$view <- NULL
  coord_export$pr <- 0
  coord_export$x <- 0
  coord_export$y <- 0


  i <- 1
  while (i <= length(prnames)){
    coord_proc <- coord[which (coord$pr==prnames[i]), ]
    yw <- c(coord_proc$y)
    xw <- c(coord_proc$x)
    fm <- lm(yw ~ xw)

    slope <- coef(fm)[2]




    if (slope < 0 && coord_proc$view[1] == "N" ||
        slope < 0 && coord_proc$view[1] == "E"){
      slope_deg <- 180 - abs((atan(slope) * 180) / pi) * -1
    } else if (slope < 0 && coord_proc$view[1] == "S" ||
               slope < 0 && coord_proc$view[1] == "W"){
      slope_deg <- abs((atan(slope)*180)/pi)
    } else if (slope > 0 && coord_proc$view[1] == "S" ||
               slope > 0 && coord_proc$view[1] == "E") {
      slope_deg <- ((atan(slope)*180)/pi)*-1
    } else if (slope > 0 && coord_proc$view[1] == "N" ||
               slope > 0 && coord_proc$view[1] == "W") {
      slope_deg <- 180 - ((atan(slope)*180)/pi)
    } else if (slope == 0 && coord_proc$view[1] == "N" ){
      slope_deg <- 180
    } else if (slope == 0 && coord_proc$view[1] == "N" ){
      slope_deg <- 0
    }

    center_x <- sum(coord_proc$x)/length(coord_proc$x)
    center_y <- sum(coord_proc$y)/length(coord_proc$y)

    coord_trans <- coord_proc
    coord_trans$view <- NULL
    for (z in 1:nrow(coord_proc)){
      coord_trans[z,] <- c(
        center_x + (coord_proc$x[z] - center_x) *
          cos(slope_deg / 180 * pi) - sin(slope_deg / 180 * pi) *
          (coord_proc$y[z] - center_y),
        center_y + (coord_proc$x[z] - center_x) *
          sin(slope_deg / 180 * pi) + (coord_proc$y[z] - center_y) *
          cos(slope_deg / 180 * pi),
        (coord_proc$z[z]+center_y-mean(coord_proc$z)),
        coord_proc$pr[z])

    }

    z_yw <- c(coord_trans$y -  min(c(coord_trans$y,coord_trans$z)))
    z_zw <- c(coord_trans$z -  min(c(coord_trans$y,coord_trans$z)))

    z_fm <- lm(z_zw ~ z_yw)
    z_slope <- coef(z_fm)[2]

    if (z_slope < 0){

      z_slope_deg <- (90 - abs((atan(z_slope)*180)/pi))*-1
    } else if (z_slope > 0){
      z_slope_deg <- 90 - ((atan(z_slope)*180)/pi)
    } else if (z_slope == 0){
      z_slope_deg <- 0
    }


    z_center_y <- sum(coord_trans$y)/length(coord_trans$y)
    z_center_z <- sum(coord_trans$z)/length(coord_trans$z)

    z_coord <- coord_trans

    for (z in 1:nrow(z_coord)){
      z_coord[z,] <- c(
        coord_trans$x[z],
        z_center_y + (coord_trans$y[z] - z_center_y) * cos(z_slope_deg / 180 * pi) -
          (coord_trans$z[z] - z_center_z) * sin(z_slope_deg / 180 * pi),
        z_center_z + (coord_trans$y[z] - z_center_y) * sin(z_slope_deg / 180 * pi) +
          (coord_trans$z[z] - z_center_z) * cos(z_slope_deg / 180 * pi),

        coord_trans$pr[z])


    }
    coord_trans <- z_coord


    coord_export[which (coord$pr==prnames[i]), ] <- coord_trans
    i<-i+1
    coord_proc <- NULL
    coord_trans <- NULL
    z_coord <- NULL
  }




  export <- SpatialPointsDataFrame(coords=coord_export[,c(1,3)],
                                   data = coord_export,
                                   proj4string = (fotogram_pts@proj4string))
output = export