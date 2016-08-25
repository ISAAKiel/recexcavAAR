library(akima)

df1 <- data.frame(
  x = rnorm(50),
  y = rnorm(50),
  z = rnorm(50) - 5
)

a <- list(x = df1$x, y = df1$y, z = df1$z)

akima.li <- interp(df1$x, df1$y, df1$z)
plot(a, pch = 3)
image  (akima.li, add=TRUE)
contour(akima.li, add=TRUE)

library(plotly)
plot_ly(x = akima.li$x, y = akima.li$y, z = akima.li$z, type = "surface", showscale = FALSE)
