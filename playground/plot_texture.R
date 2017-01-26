library(rgl)
library(jpeg)

# download and load picture
download.file(
  url = 'https://www.thefactsite.com/wp-content/uploads/2013/01/chewbacca.jpg',
  destfile = "chewbacca.jpg",
  mode = 'wb'
)

jj <- readJPEG("chewbacca.jpg", native = TRUE)

# sample data
x <- sort(rnorm(1000))
y <- rnorm(1000)
z <- rnorm(1000) + atan2(x, y)

# plot
plot3d(x, y, z, col = rainbow(1000))
show2d(
  {
  plot(0:1,0:1,type="n",ann=FALSE,axes=FALSE)
  rasterImage(jj,0,0,1,1)
  },
  # coord order: lower left, lower right, upper right and upper left
  x = c(-3,2,2,-3),
  y = c(-1,-1,1,1),
  z = c(-3,-3,2,2)
)


