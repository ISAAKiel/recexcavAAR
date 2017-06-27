#' Tool for rotating profile control points form rectifiying images
#'
#'
#' @param fotogram_pts SpatialDataFrame A SpatialDataFrame containing the control points (3 Dimensions)
#' @param profile_col Name of the column containing the profile group variable (Profilenumber)
#' @param view_col Name of the profile containing the viewing direction (N,S,W,E)
#' @param view Direction of view on the Profile (surface = orthogonal to the surface of the profile, Standard is a view on a vertial intersecting pane (like a drawing)).
#' @param direction Position of the profile control points. (horizontal = Profile is horizontal, the relative heigth is still correct, good for catalouge export; original = the points are on the profile section)
#' @return SpatialDataFrame with the new coordinates
#' @examples
#'
#' fotogram_sdf <- sp::SpatialPointsDataFrame(coords = fotogram_pts[ ,c(1,2,3)],
#' data <- fotogram_pts,
#' proj4string = sp::CRS('+proj=utm +zone=32 +ellps=GRS80 +units=m +no_defs'))
#'
#' profile <- archProfile(
#'   fotogram_pts = fotogram_sdf,
#'   profile_col = "pr",
#'   view_col = "view",
#' )
#'
#' @export
archProfile <- function(fotogram_pts, profile_col, view_col, view = "projected", direction = "horizontal"){


  #Die Datei muss zwei Spalten haben, zum einen die mit der Gruppierung
  #für die Profile (z.B. Profilnummer), und (optional) eine
  #Spalte mit der view von N/S/E/W, damit das Profil richtig gedreht werden kann
  #Spalte mit dem Namen raussuchen und den Spaltenindex merken
  profile_id <- 1
  while(profile_id<length(colnames(fotogram_pts@data)) &&
        colnames(fotogram_pts@data)[profile_id] != profile_col)
  {
    profile_id <- profile_id+1
  }

  #Spalte mit dem NAmen raussuchen und den Spaltenindex merken
  view_id <- 1
  while(view_id<length(colnames(fotogram_pts@data)) &&
        colnames(fotogram_pts@data)[view_id] != view_col)
  {
    view_id <- view_id+1
  }


  #Die Punkte mssen umden Mittelpunkt rotiert werden,
  #sodass sie parallel zur x achse liegen
  #Bedingung alle Pkt mssen mglichst auf einer Ebene liegen
  #Dazu Koordinaten in Dataframe schreiben
  coord <- data.frame(fotogram_pts@coords[ ,1],
                      fotogram_pts@coords[ ,2],
                      fotogram_pts@coords[ ,3],
                      fotogram_pts@data[ ,profile_id],
                      fotogram_pts@data[, view_id])
  colnames(coord) <- c("x", "y", "z", "pr","view")


  #Jetzt muss jedes Profil einzeln bearbeitet werden
  #Nas raus
  coord <- na.omit(coord)
  #Alle Namen der Profile ermitteln, da sich daraus die
  #Anzahl der Schleifenduchläufe bestimmt
  prnames <- levels(as.factor(coord$pr))
  #Eine Tabelle, die für den Export da ist,
  #mit der gleichen Datenlänge wie die importierte
  #Da dieser df am ende immer wieder neue daten angehängt bekommt
  #und das rbind mit df blöd ist, wird hier eine Kopie der orginaltabelle überschrieben
  #damit fehler auffallen, sind alle Spalten = 0; Auch wenn es sehr unelegant ist
  coord_export <- coord
  coord_export$view <- NULL
  coord_export$pr <- 0
  coord_export$x <- 0
  coord_export$y <- 0


  i <- 1
  #Jetzt jedes Profil durchlaufen
  while (i <= length(prnames)){
    #Alle Daten des iten Profils auslesen und in temporären dataframe schreiben
    coord_proc <- coord[which (coord$pr==prnames[i]), ]
    #nun die Mittelline bestimmen -> lieare Regression
    #Entspricht dem BKS in AutoCAD, allerdings in 2D.
    #Je gerader die Profile, desto genauer. Man könnte auch mit Matritzen arbeiten,
    #ich denke aber, dass das übertrieben ist.

    #Um die Abweichungen in des ungeraden Profils etwas auszugleichen,
    #wird eine Augleichsgerade zwischen die Punkte geschrieben
    #Dazu wird eine lineare Regression verwendet
    yw <- c(coord_proc$y)
    xw <- c(coord_proc$x)
    fm <- lm(yw ~ xw)

    #Um die Fotogrammetrienägel korrekt anzeigen zu können, sollen diese gedreht werden.
    #Dazu muss der Winkel zwischen der Regressionsgerade und der x-Achse berechnet werden
    #Steigung der Gerade
    slope <- coef(fm)[2]

    #Nun muss unterschieden werden, ob das Profil im oder gegen der
    #Uhrzeigersinn gedreht werden muss.
    #Das wird durch 2 Parameter bestimmt, Steigung und view.
    #Es gibt vier Fälle (Sonderfälle sind m = 0)
    #1. m = - view = N/E -> im Uhrzeigersinn
    #2. m = - view = S/W -> gegen Uhrzeigersinn
    #3. m = + view = S/E -> im Uhrzeigersinn
    #4. m = + view = N/W -> gegen Uhrzeigersinn
    #Dafür die Drehwinkel bestimmen (rad -> deg)



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

    #Nun den Drehpunkt bestimmen.
    #X-Wert ist die Mitte zwischen den x-Koordinaten
    center_x <- sum(coord_proc$x)/length(coord_proc$x)
    #Y-Wert
    center_y <- sum(coord_proc$y)/length(coord_proc$y)
    #Nun um diesen Punkt drehen

    coord_trans <- coord_proc
    #Die Spalte view fällt raus
    coord_trans$view <- NULL
    #Für jeden Punkt des Profils mittels translation
    #und rotation den neuen Punkt bestimmen
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
      #http://www.matheboard.de/archive/460078/thread.html

    }

    if (view == "surface"){
      #Jetzt das ganze für die z-Achse, um eine Kippung des Profils zu minimieren

      z_yw <- c(coord_trans$y -  min(c(coord_trans$y,coord_trans$z)))
      z_zw <- c(coord_trans$z -  min(c(coord_trans$y,coord_trans$z)))

      z_fm <- lm(z_zw ~ z_yw)


      #Steigungswinkel berechnen
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
        #http://www.matheboard.de/archive/460078/thread.html

      }
      coord_trans <- z_coord
    }


    if (direction == "original"){
      y_xw <- c(coord_trans$x -  min(c(coord_trans$x,coord_trans$z)))
      y_zw <- c(coord_trans$z -  min(c(coord_trans$x,coord_trans$z)))

      y_fm <- lm(y_zw ~ y_xw)


      #Der Drehwinkel ist in diesem Falle der negative Drehwinkel des ersten Schrittes
      y_slope_deg <- slope_deg * -1


      y_center_x <- sum(coord_trans$x)/length(coord_trans$x)
      y_center_z <- sum(coord_trans$z)/length(coord_trans$z)

      y_coord <- coord_trans

      for (z in 1:nrow(y_coord)){
        y_coord[z,] <- c(
          y_center_x + (coord_trans$x[z] - y_center_x) * cos(y_slope_deg / 180 * pi) -
            (coord_trans$z[z] - y_center_z) * sin(y_slope_deg / 180 * pi),
          coord_trans$y[z],
          y_center_z + (coord_trans$x[z] - y_center_x) * sin(y_slope_deg / 180 * pi) +
            (coord_trans$z[z] - y_center_z) * cos(y_slope_deg / 180 * pi),
          coord_trans$pr[z])
        #http://www.matheboard.de/archive/460078/thread.html

      }
      coord_trans <- y_coord
    }


    #Dann passend in den dataframe speichern
    coord_export[which (coord$pr==prnames[i]), ] <- coord_trans
    i<-i+1
    #temporären dataframe löschen
    coord_proc <- NULL
    coord_trans <- NULL

    if (view == "surface"){
      z_coord <- NULL
    }

  }




  #Das ganze zu einem Spatialdataframe machen
  export <- SpatialPointsDataFrame(coords=coord_export[,c(1,3)],
                                   data = coord_export,
                                   proj4string = (fotogram_pts@proj4string))


return(export)
}