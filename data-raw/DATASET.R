library("JACUSA2helper")
library("BSgenome.Hsapiens.NCBI.GRCh38")

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
DARTseq <- JACUSA2helper:::read_result("Score2_APOBEC1YTH_APOBEC1YTHmut_RC18_call2_result.out", unpack = TRUE)
usethis::use_data(DARTseq, overwrite = TRUE, compress = "bzip2")

MazF_FTO <- JACUSA2helper:::read_result("Cutoff01_MazF_vs_cond2_FTO_RC22_rtarrest_with_seq.out", unpack=TRUE)
usethis::use_data(MazF_FTO, overwrite = TRUE, compress = "bzip2")

m6a_miclip <- rtracklayer::import("miCLIP_union_flat_exclude_Y_chromosome.bed")
m6a_miclip <- sort(m6a_miclip)
m6a_miclip <- m6a_miclip[GenomicRanges::seqnames(m6a_miclip) %in% c(1:22, "MT", "X"), "name"]
GenomeInfoDb::seqlevels(m6a_miclip, pruning.mode = "coarse") <- c(1:22, "MT", "X")
colnames(GenomicRanges::mcols(m6a_miclip)) <- "experiments"
GenomeInfoDb::seqlengths(m6a_miclip) <- GenomeInfoDb::seqlengths(BSgenome.Hsapiens.NCBI.GRCh38)[names(GenomeInfoDb::seqlengths(m6a_miclip))]
usethis::use_data(m6a_miclip, overwrite = TRUE, compress = "bzip2")

m6a_nmf_results <- readRDS("nmf_results_paper.rds")
usethis::use_data(m6a_nmf_results, overwrite = TRUE, compress = "bzip2")
