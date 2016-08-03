context("Tests of function spatialwide")

x <- c(1, 1, 1, 2, 2, 2, 3, 3, 4)
y <- c(1, 2, 3, 1, 2, 3, 1, 2, 3)
z <- c(3, 4, 2, 3, NA, 5, 6, 3, 1)
d <- 3

df <- data.frame(x, y, z)
res <- spatialwide(df$x, df$y, df$z, digits = d)

test_that(
  "the output of spatialwide is a data.frame",  {
    expect_equal(
      is.data.frame(res),
      TRUE
    )
  }
)

test_that(
  "the output of spatialwide has the correct amount of rows and columns",  {
    expect_equal(
      ncol(res),
      length(unique(df$x))
    )
    expect_equal(
      nrow(res),
      length(unique(df$y))
    )
  }
)

test_that(
  "the output of spatialwide has the correct rownames and colnames",  {
    expect_equal(
      colnames(res),
      as.character(round(unique(df$x), d))
    )
    expect_equal(
      rownames(res),
      as.character(round(unique(df$y), d))
    )
  }
)

test_that(
  "the output of spatialwide contains the correct values at the correct places (random sample)",  {
    expect_equal(
      res[1, 2],
      3
    )
    expect_equal(
      res[3, 1],
      2
    )
    expect_equal(
      is.na(res[2, 4]),
      TRUE
    )
  }
)