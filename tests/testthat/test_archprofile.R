context("Tests of function archprofile")

#### prepare test data ####
# archprofile_input_1 <- sp::SpatialPointsDataFrame(
#   coords = archprofile_test[, c(1,2,3)],
#   data = archprofile_test,
#   proj4string = sp::CRS("+proj=utm +zone=32 +ellps=GRS80 +units=m +no_defs")
# )
# save(archprofile_input_1, file = "tests/testthat/data/archprofile_input_1.RData")
# load("tests/testthat/data/archprofile_input_1.RData")
load("data/archprofile_input_1.RData")

# archprofile_output_1_correct <- archprofile(
archprofile_output_1 <- archprofile(
  fotogram_pts = archprofile_input_1,
  profile_col = "pr",
  view_col = "pr1"
)
#save(archprofile_output_1_correct, file = "tests/testthat/data/archprofile_output_1_correct.RData")
# load("tests/testthat/data/archprofile_output_1_correct.RData")
load("data/archprofile_output_1_correct.RData")

test_that(
  "the output of archprofile is the same as before the code refactoring for a very limited example",  {
    expect_equal(archprofile_output_1, archprofile_output_1_correct)
  }
)
