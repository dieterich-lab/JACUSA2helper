library("JACUSA2helper")

# Piechotta2017 data TODO use real data from JACUSA2
prefix <- "call-2-"

rdd <- read_result(paste0(prefix, "rdd", ".out"))
usethis::use_data(rdd)

rrd <- read_result(paste0(prefix, "rrd", ".out"))
usethis::use_data(rrd)


# Zhou2018 data
prefix <- "rt-arrest-"

HIVRT <- read_result(paste0(prefix, "HIVRT", ".out"))
usethis::use_data(HIVRT)

SIIIRTMn <- read_result(paste0(prefix, "SIIIRTMn", ".out"))
usethis::use_data(SIIIRTMn)

SIIIRTMg <- read_result(paste0(prefix, "SIIIRTMg", ".out"))
usethis::use_data(SIIIRTMg)

meta_conditions <- c("HIVRT", "SIIIRTMn", "SIIIRTMg")
inputs <- paste0(prefix, meta_conditions, ".out")
Zhou2018 <- read_results(inputs, meta_conditions)
usethis::use_data(Zhou2018)
