library(rgl)
library(jpeg)

# download and load picture
download.file(
  url = 'https://upload.wikimedia.org/wikipedia/en/6/6d/Chewbacca-2-.jpg',
  destfile = "chewbacca.jpg",
  mode = 'wb'
)

chewie <- readJPEG("chewbacca.jpg", native = TRUE)

# create some sample data
x <- sort(rnorm(1000))
y <- rnorm(1000)
z <- rnorm(1000) + atan2(x, y)

# plot sample data
plot3d(x, y, z, col = rainbow(1000), size = 5)

# add picture
show2d(
  # plot raster
  {
    par(mar = rep(0, 4))
    plot(
      0:1, 0:1, type="n",
      ann = FALSE, axes = FALSE,
      xaxs = "i", yaxs = "i"
    )
    rasterImage(chewie, 0, 0, 1, 1)
  },
  # image position and extent
  # coordinate order: lower left, lower right, upper right and upper left
  x = c(-2,  1,  1, -2),
  y = c(-1, -1,  1,  1),
  z = c(-3, -3,  2,  2)
)