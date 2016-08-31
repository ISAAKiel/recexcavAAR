library(devtools)

#### KT tables ####
KT_squarecorners <- read.csv("data-raw/KT_squarecorners.csv", sep = ";")
KT_spits <- read.csv("data-raw/KT_spits.csv", sep = ";")

devtools::use_data(KT_squarecorners, KT_spits, overwrite = TRUE)

#### KT small datasets ####
vesselsingle <- data.frame(
  inv = c("KTF_123", "KTF_167", "KTF_179"),
  spit = c("spit1", "spit1", "spit2"),
  square = c("20", "20", "13"),
  feature = c("3", "3", "5"),
  x = c(5.493, 5.349, 6.006),
  y = c(15.061, 15.075, 16.677),
  z = c(9.556, 9.611, 9.253)
)

vesselmass <- data.frame(
  inv = c("KTM_45", "KTM_56", "KTM_77", "KTM_98"),
  spit = c("spit2", "bottom", "spit1", "bottom"),
  square = c("20", "35", "47", "25"),
  feature = c("5", "5", "7", "3"),
  x = NA,
  y = NA,
  z = NA
)

KT_vessel <- rbind(vesselsingle, vesselmass)

devtools::use_data(KT_vessel, overwrite = TRUE)
