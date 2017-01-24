context("Tests of coordinate transformation function")

coord_data <- data.frame(
 loc_x = c(1, 3, 1, 3),
 loc_y = c(1, 1, 3, 3),
 abs_x = c(107.1, 107, 104.9, 105),
 abs_y = c(105.1, 107, 105.1, 106.9)
)

data_table <- data.frame(
 x = c(1.5, 1.2, 1.6, 2),
 y = c(1, 5, 2.1, 2),
 type = c("flint","flint","pottery","bone")
)

new_frame <- suppressMessages(
  cootrans(coord_data, c(1, 2, 3, 4), data_table, c(1, 2))
)

test_that(
  "the output of the transformation function is a data.frame", {
    expect_true(
      is.data.frame(new_frame)
    )
  }
)

test_that(
  "the output data.frame of the transformation function
  has the correct colnames", {
    expect_equal(
      colnames(new_frame),
      c("x", "y", "type", "abs_x", "abs_y")
    )
  }
)