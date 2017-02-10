#' Tool for transforming local metric coordinates
#'
#' This function transforms local metric coordinates to absolute coordinates of referenced
#' systems by use of a two dimensional four parameter Helmert transformation. This function does
#' not cover the transformation of three dimensional points or transformation between two different
#' datums.
#'
#' @param pair_matrix data.frame or matrix with pairs of local and corresponding absolute coordinates (Minimum two!)
#' @param pm_column vector with numerical index of the columns in order: local x-value, local y-value, absolute x-value, absolute y-value
#' @param data_matrix data.frame with local x- and y-values which schould be transformed.
#' @param dm_column vector with numerical index of the columns in order: local x-value, local y-value.
#' @param checking boolean switch to turn on the checking ability. Default: FALSE. If TRUE showes combined coordinate plots with indexed points and alters return of function.
#' @param checkplot boolean switch to turn off the checking plot. Default: TRUE. Only matters if checking == TRUE.
#'
#' @return Original data.frame with additional columns containing the absolute x- and y-coordinates. In case of 'checking = TRUE' returns pair_matrix data.frame with additional columns of scale and rotation arc in degrees.
#'
#' @examples
#' coord_data <- data.frame(
#'  loc_x = c(1,3,1,3),
#'  loc_y = c(1,1,3,3),
#'  abs_x = c(107.1,107,104.9,105),
#'  abs_y = c(105.1,107,105.1,106.9)
#' )
#'
#' data_table <- data.frame(
#'  x = c(1.5,1.2,1.6,2),
#'  y = c(1,5,2.1,2),
#'  type = c("flint","flint","pottery","bone")
#' )
#'
#' new_frame <- cootrans(coord_data, c(1,2,3,4), data_table, c(1,2))
#'
#' check_data <- cootrans(coord_data, c(1,2,3,4), data_table, c(1,2), checking = TRUE)
#'
#' @export
#'


cootrans <- function(
  pair_matrix,
  pm_column,
  data_matrix,
  dm_column,
  checking = FALSE,
  checkplot = TRUE
  ){

  # 0. initial stuff
  # 0.1 define vector calculation function
  v_func <- function(x_col, y_col, sp){

    vec_x <- x_col - sp[1]
    vec_y <- y_col - sp[2]

    vec_s <- sqrt(vec_x**2 + vec_y**2)
    vec_a <- ifelse(vec_x < 0, -acos(vec_y / vec_s), acos(vec_y / vec_s))

    returnpackage <- data.frame(m = vec_s, alpha = vec_a)
    return(returnpackage)
  }

  # 0.2 set column indices
  Lx_col <- pm_column[1]
  Ly_col <- pm_column[2]
  Ax_col <- pm_column[3]
  Ay_col <- pm_column[4]

  tx_col <- dm_column[1]
  ty_col <- dm_column[2]

  # 1. get helmert parameters
  # 1.1 calculate local and absolute centroid
  sp_loc <- c(mean(pair_matrix[,Lx_col]), mean(pair_matrix[,Ly_col]))
  sp_abs <- c(mean(pair_matrix[,Ax_col]), mean(pair_matrix[,Ay_col]))

  # 1.2 vector attributes
  loc_v <- v_func(pair_matrix[,Lx_col], pair_matrix[,Ly_col], sp_loc)
  abs_v <- v_func(pair_matrix[,Ax_col], pair_matrix[,Ay_col], sp_abs)

  # 1.3 Scalation
  vec_m <- abs_v$m / loc_v$m
  sc <- mean(vec_m[is.infinite(vec_m) == FALSE & is.nan(vec_m) == FALSE])
  sc_std <- stats::sd(vec_m[is.infinite(vec_m) == FALSE & is.nan(vec_m) == FALSE])

  # 1.4 rotation arc
  vec_a <- (abs_v$alpha - loc_v$alpha) %% (2*pi)
  alpha <- mean(vec_a[is.nan(vec_a) == FALSE])
  alpha_std <- stats::sd(vec_a[is.nan(vec_a) == FALSE])

  # 1.5 out print for checking transforamtion
  message(
    paste(c(
      "Transformation:", "\n",
      "local centroid:", sp_loc, "\n",
      "absolute centroid:", sp_abs, "\n",
      "scale:", sc, "\n",
      "rotation arc:", (alpha*180)/pi
    ), collapse = " ")
  )
  if ((alpha_std >= 0.1) | (sc_std >= 0.1)){
    warning("High deviations! Some coordinates may be mapped incorrectly.")
  }

  # 1.6 special: checking function
  if(checking){
    nr <- c(1:length(pair_matrix[,1]))
    index <- data.frame(
      pair_matrix,
      nr
    )

    if(checkplot){
      # change par settings
      graphics::par(mfrow = c(1,2))

      # plot
      graphics::plot(index[,Lx_col], index[,Ly_col],
           main = "Local coordinates",
           xlab = "Local x-value",
           ylab = "Local y-value",
           cex = 2)
      graphics::text(index[,Lx_col], index[,Ly_col],
           labels = index$nr,
           cex = 0.7)

      graphics::plot(index[,Ax_col],index[,Ay_col],
           main = "Absolute coordinates",
           xlab = "Absolute x-value",
           ylab = "Absolute y-value",
           cex = 2)
      graphics::text(index[,Ax_col], index[,Ay_col],
           labels = index$nr,
           cex = 0.7)

      # restore original par settings
      graphics::par(mfrow = c(1,1))
    }

    out_frame <- data.frame(
      pair_matrix,
      scalation = vec_m,
      rotation = (vec_a*180/pi)
    )

  }
  else{

    # 2. transformation
    # 2.1 vector attributes
    vs <- v_func(data_matrix[,tx_col], data_matrix[,ty_col], sp_loc)
      # 2.2 calculating new coordinates
    Ax <- ifelse(is.nan(vs$alpha), sp_abs[1], sp_abs[1] + sc * vs$m * sin((vs$alpha + alpha)))
    Ay <- ifelse(is.nan(vs$alpha), sp_abs[2], sp_abs[2] + sc * vs$m * cos((vs$alpha + alpha)))

    # 3. append data
    out_frame <- data.frame(data_matrix, abs_x = Ax, abs_y = Ay)

  }
  return(out_frame)
}