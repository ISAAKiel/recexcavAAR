library(devtools)

KT_squarecorners <- read.csv("data-raw/KT_squarecorners.csv", sep = ";")
KT_spits <- read.csv("data-raw/KT_spits.csv", sep = ";")

devtools::use_data(KT_squarecorners, KT_spits, overwrite = TRUE)