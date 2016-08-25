library(plotly)

#### preparations ####
edges <- data.frame(
  x = c(0, 3, 0, 3, 0, 3, 0, 3),
  y = c(0, 0, 0, 0, 1, 1, 1, 1),
  z = c(0, 0, 2, 2, 0, 0, 2, 2)
)

vis <- plot_ly(edges, x = x, y = y, z = z, type = "scatter3d", mode = "markers"
) %>%
  layout(
    showlegend = FALSE,
    autorange = F,
    aspectmode = 'manual',
    scene = list(
      dragmode = "orbit",
      aspectratio = list(x=3, y=1, z=3),
      camera = list(
        eye = list(x = 4, y = 4, z = 1)
      )
    )
  )

df1 <- data.frame(
  x = c(rep(0, 6), seq(0.2, 2.8, 0.2), seq(0.2, 2.8, 0.2), rep(3,6)),
  y = c(seq(0, 1, 0.2), rep(0, 14), rep(1, 14), seq(0, 1, 0.2)),
  z = c(0.9+0.05*rnorm(6), 0.9+0.05*rnorm(14), 1.3+0.05*rnorm(14), 1.2+0.05*rnorm(6))
)

vis <- vis %>%
  add_trace(data = df1, x = x, y = y, z = z,
            mode = "markers", type = "scatter3d",
            marker = list(size = 4, color = "red", symbol = 104)
  )

a <- list(x = df1$x, y = df1$y, z = df1$z)

#### akima ####
library(akima)
akima.li <- interp(df1$x, df1$y, df1$z)
# plot(a, pch = 3)
# image  (akima.li, add=TRUE)
# contour(akima.li, add=TRUE)
vis %>% add_trace(
  x = akima.li$x,
  y = akima.li$y,
  z = akima.li$z,
  type = "surface",
  showscale = FALSE
  )

#### geometry ####
library(alphashape3d)
ashape3d.obj <- ashape3d(as.matrix(df1), alpha = 0.7)
plot(ashape3d.obj)
# ok - this is something completly different. But it could be incredibly useful...