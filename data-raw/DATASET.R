library("JACUSA2helper")

# Piechotta2017 data
prefix <- "call-2-"

rdd <- JACUSA2helper:::read_result(paste0(prefix, "rdd", ".out"), unpack = TRUE)
usethis::use_data(rdd, overwrite = TRUE, compress = "bzip2")

rrd <- JACUSA2helper:::read_result(paste0(prefix, "rrd", ".out"), unpack = TRUE)
usethis::use_data(rrd, overwrite = TRUE, compress = "bzip2")

# Data generated
rnam <- read.table("rnam.bed", header = FALSE, comment.char = "#", stringsAsFactors = FALSE)
colnames(rnam)[c(1, 3, 4)] <- c("rrna", "pos", "base")
rnam <- rnam[, c("rrna", "pos", "base")]
usethis::use_data(rnam, overwrite = TRUE, compress = "bzip2")


# Zhou2018 data - call-2
meta_conds <- c("HIVRT", "SIIIRTMn", "SIIIRTMg")
cond_descs <- replicate(3, c("+GMC", "-GMC"), simplify = FALSE)

HIVRT_call2 <- JACUSA2helper:::read_result("call-2-HIVRT.out", unpack = TRUE)
usethis::use_data(HIVRT_call2, overwrite = TRUE, compress = "bzip2")

SIIIRTMn_call2 <- JACUSA2helper:::read_result("call-2-SIIIRTMn.out", unpack = TRUE)
usethis::use_data(SIIIRTMn_call2, overwrite = TRUE, compress = "bzip2")

SIIIRTMg_call2 <- JACUSA2helper:::read_result("call-2-SIIIRTMg.out", unpack = TRUE)
usethis::use_data(SIIIRTMg_call2, overwrite = TRUE, compress = "bzip2")

fnames <- paste0("call-2-", meta_conds, ".out")
Zhou2018_call2 <- JACUSA2helper:::read_results(fnames, meta_conds, cond_descs)
usethis::use_data(Zhou2018_call2, overwrite = TRUE, compress = "bzip2")

# Zhou2018 data - rt-arrest
meta_conds <- c("HIVRT", "SIIIRTMn", "SIIIRTMg")
cond_descs <- replicate(3, c("+GMC", "-GMC"), simplify = FALSE)

HIVRT_rt_arrest <- JACUSA2helper:::read_result("rt-arrest-HIVRT.out", unpack = TRUE)
usethis::use_data(HIVRT_rt_arrest, overwrite = TRUE, compress = "bzip2")

SIIIRTMn_rt_arrest <- JACUSA2helper:::read_result("rt-arrest-SIIIRTMn.out", unpack = TRUE)
usethis::use_data(SIIIRTMn_rt_arrest, overwrite = TRUE, compress = "bzip2")

SIIIRTMg_rt_arrest <- JACUSA2helper:::read_result("rt-arrest-SIIIRTMg.out", unpack = TRUE)
usethis::use_data(SIIIRTMg_rt_arrest, overwrite = TRUE, compress = "bzip2")

fnames <- paste0("rt-arrest-", meta_conds, ".out")
Zhou2018_rt_arrest <- JACUSA2helper:::read_results(fnames, meta_conds, cond_descs)
usethis::use_data(Zhou2018_rt_arrest, overwrite = TRUE, compress = "bzip2")

# DARtSeq
DARTseq <- JACUSA2helper:::read_result("Score2_APOBEC1YTH_APOBEC1YTHmut_RC18_call2_result.out")
usethis::use_data(DARTseq, overwrite = TRUE, compress = "bzip2")

MazF_FTO <- JACUSA2helper:::read_result("Cutoff01_MazF_vs_cond2_FTO_RC22_rtarrest_with_seq_and_ann.out", unpack=TRUE)
usethis::use_data(MazF_FTO, overwrite = TRUE, compress = "bzip2")
# MazF
#MazF <- JACUSA2helper:::read_result("Cutoff005_MazF_vs_cond2_FTO_RC18_rtarrest_plain_result.out")
#usethis::use_data(MazF, overwrite = TRUE, compress = "bzip2")
# ACA
#pos <- c("contig", "start", "end", "strand")
#ACA <- read.table("ACA.txt", col.names=c(pos, "motif"), header = FALSE, stringsAsFactors = FALSE)
#ACA$coord <- JACUSA2helper:::coord(ACA)
#usethis::use_data(ACA, overwrite = TRUE, compress = "bzip2")
