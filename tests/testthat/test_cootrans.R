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

wrong_data <- data.frame(
  loc_x = c(1, 3, 1, 3),
  loc_y = c(1, 3, 3, 1),
  abs_x = c(107.1, 107, 104.9, 105),
  abs_y = c(105.1, 107, 105.1, 106.9)
)

check_data <- suppressMessages(
  cootrans(wrong_data, c(1, 2, 3, 4), data_table, c(1, 2), checking = TRUE)
)
#####
#####

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

test_that("the input data.frames have minimum number of columns",
          { expect_gte(length(colnames(coord_data)), 4)
            expect_gte(length(colnames(data_table)), 2)
            }
          )

test_that("the output data.frame has two additional columns",
          { expect_equal(length(colnames(new_frame)), length(colnames(data_table))+2)
            }
          )

test_that("wrong assignement of coordinates returns a warning message",
          { expect_warning(cootrans(wrong_data, c(1, 2, 3, 4), data_table, c(1, 2)))
            }
          )

test_that("with testing=TRUE resulting check_data data.frame is the original data.frame with two additional columns",
          { expect_identical(wrong_data, check_data[,1:(length(colnames(check_data))-2)])
            }
          )

test_that("with testing=TRUE output data.frame has the correct colnames",
          { expect_equal(colnames(check_data), c("loc_x", "loc_y", "abs_x", "abs_y", "scalation", "rotation"))
            }
          )