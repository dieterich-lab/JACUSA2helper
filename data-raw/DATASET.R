library("JACUSA2helper")

# Piechotta2017 data TODO use real data from JACUSA2
prefix <- "call-2-"

rdd <- read_result(paste0(prefix, "rdd", ".out"), unpack = TRUE)
usethis::use_data(rdd, overwrite = TRUE, compress = "bzip2")

rrd <- read_result(paste0(prefix, "rrd", ".out"), unpack = TRUE)
usethis::use_data(rrd, overwrite = TRUE, compress = "bzip2")

# Fournier data http://people.biochem.umass.edu/fournierlab/3dmodmap/
modmap <- read.table("fournier_db.txt", header = TRUE, comment.char = "", stringsAsFactors = FALSE)
colnames(modmap)[c(1, 3, 4)] <- c("rrna", "pos", "base")
modmap <- modmap[, c("rrna", "pos", "base")]
usethis::use_data(modmap, overwrite = TRUE, compress = "bzip2")

# Zhou2018 data
prefix <- "rt-arrest-"

HIVRT <- read_result(paste0(prefix, "HIVRT", ".out"), unpack = TRUE)
usethis::use_data(HIVRT, overwrite = TRUE, compress = "bzip2")

SIIIRTMn <- read_result(paste0(prefix, "SIIIRTMn", ".out"), unpack = TRUE)
usethis::use_data(SIIIRTMn, overwrite = TRUE, compress = "bzip2")

SIIIRTMg <- read_result(paste0(prefix, "SIIIRTMg", ".out"), unpack = TRUE)
usethis::use_data(SIIIRTMg, overwrite = TRUE, compress = "bzip2")

meta_conds <- c("HIVRT", "SIIIRTMn", "SIIIRTMg")
cond_descs <- replicate(3, c("+GMC", "-GMC"), simplify = FALSE)
inputs <- paste0(prefix, meta_conds, ".out")
Zhou2018 <- read_results(inputs, meta_conds, cond_descs)
usethis::use_data(Zhou2018, overwrite = TRUE, compress = "bzip2")

#TEST <-read_result("test.out", unpack = TRUE, cores = 2)
#TEST$tag <- clean_tag(TEST$tag)
#usethis::use_data(TEST, overwrite = TRUE)