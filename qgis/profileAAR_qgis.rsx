## fotogram_pts = vector
## profile_col = string
## view_col = string
## view_ = selection projected;surface
## direction_ = selection horizontal;original
## output = output vector

if(!("rgdal" %in% rownames(installed.packages()))) install.packages("rgdal")
require(rgdal)



if (view_ == 0){
view <- "projected"
} else {
view <- "surface"
}

if (direction_ == 0){
direction <- "horizontal"
} else {
direction <- "original"
}

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


  coord <- data.frame(
    x = fotogram_pts@coords[, 1],
    y = fotogram_pts@coords[, 2],
    z = fotogram_pts@coords[, 3],
    pr = fotogram_pts@data[, profile_col],
    view = fotogram_pts@data[, view_col]
  )

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
    yw <- c(coord_proc$y)
    xw <- c(coord_proc$x)
    fm <- lm(yw ~ xw)

    #Um die Fotogrammetrienaegel korrekt anzeigen zu koennen, sollen diese gedreht werden.
    #Dazu muss der Winkel zwischen der Regressionsgerade und der x-Achse berechnet werden
    #Steigung der Gerade
    slope <- coef(fm)[2]

    #Nun muss unterschieden werden, ob das Profil im oder gegen der
    #Uhrzeigersinn gedreht werden muss.
    #Das wird durch 2 Parameter bestimmt, Steigung und view.
    #Es gibt vier Faelle (Sonderfaelle sind m = 0)
    #1. m = - view = N/E -> im Uhrzeigersinn
    #2. m = - view = S/W -> gegen Uhrzeigersinn
    #3. m = + view = S/E -> im Uhrzeigersinn
    #4. m = + view = N/W -> gegen Uhrzeigersinn
    #Dafuer die Drehwinkel bestimmen (rad -> deg)

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

    #Nun den Drehpunkt bestimmen.
    #X-Wert ist die Mitte zwischen den x-Koordinaten
    center_x <- sum(coord_proc$x) / nrow(coord_proc)
    #Y-Wert
    center_y <- sum(coord_proc$y) / nrow(coord_proc)
    #Nun um diesen Punkt drehen

    coord_trans <- coord_proc

    #Die Spalte view faellt raus
    coord_trans$view <- NULL
    #Fuer jeden Punkt des Profils mittels Translation
    #und Rotation den neuen Punkt bestimmen
    for (z in 1:nrow(coord_proc)) {
      coord_trans[z,] <- c(
        center_x + (coord_proc$x[z] - center_x) *
          cos(slope_deg / 180 * pi) - sin(slope_deg / 180 * pi) *
          (coord_proc$y[z] - center_y),
        center_y + (coord_proc$x[z] - center_x) *
          sin(slope_deg / 180 * pi) + (coord_proc$y[z] - center_y) *
          cos(slope_deg / 180 * pi),
        coord_proc$z[z] + center_y - mean(coord_proc$z), as.numeric(as.character(coord_trans$pr[z]))
      )


      #http://www.matheboard.de/archive/460078/thread.html
    }


    if (view == "surface") {
      #Jetzt das ganze fuer die z-Achse, um eine Kippung des Profils zu minimieren

      z_yw <- c(coord_trans$y - min(c(coord_trans$y, coord_trans$z)))
      z_zw <- c(coord_trans$z - min(c(coord_trans$y, coord_trans$z)))
      z_fm <- lm(z_zw ~ z_yw)

      #Steigungswinkel berechnen
      z_slope <- coef(z_fm)[2]

      if (z_slope < 0) {
        z_slope_deg <- -(90 - abs((atan(z_slope) * 180) / pi))
      } else if (z_slope > 0) {
        z_slope_deg <- 90 - ((atan(z_slope) * 180) / pi)
      } else if (z_slope == 0) {
        z_slope_deg <- 0
      }

      z_center_y <- sum(coord_trans$y) / nrow(coord_trans)
      z_center_z <- sum(coord_trans$z) / nrow(coord_trans)

      z_coord <- coord_trans

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
      coord_trans <- z_coord
    }

    if (direction == "original") {
      y_xw <- c(coord_trans$x -  min(c(coord_trans$x, coord_trans$z)))
      y_zw <- c(coord_trans$z -  min(c(coord_trans$x, coord_trans$z)))
      y_fm <- lm(y_zw ~ y_xw)


      #Der Drehwinkel ist in diesem Falle der negative Drehwinkel des ersten Schrittes
      y_slope_deg <- -slope_deg

      y_center_x <- sum(coord_trans$x) / nrow(coord_trans)
      y_center_z <- sum(coord_trans$z) / nrow(coord_trans)

      y_coord <- coord_trans


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
      coord_trans <- y_coord
    }
    #Dann passend in den dataframe speichern
    coord_export[which(coord$pr == prnames[i]),] <- coord_trans
    coord_export[which(coord$pr == prnames[i]),]$pr <- as.numeric(as.character(coord_trans$pr))
    i <- i + 1
    #temporaeren dataframe loeschen
    coord_proc <- NULL
    coord_trans <- NULL

    if (view == "surface") {
      z_coord <- NULL
    }

  }

  #Das ganze zu einem Spatialdataframe machen
  export <- SpatialPointsDataFrame(
    coords = coord_export[, c(1, 3)],
    data = coord_export,
    proj4string = fotogram_pts@proj4string
  )

output = export
