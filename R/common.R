#' JACUSA2helper: A package for post-processing JACUSA 1.x and 2.x result files.
#'
#' The JACUSA2helper package provides the following categories of important functions:
#' input/output, get, add, and filter to post-process result files of JACUSA 2.x.
#' 
#' \itemize{
#'  \item[call{1,2}]calling variants from one condition or condition comparisons.
#'  \item[pileup] TODO
#'  \item[rt-arrest] identificaion of RNA modifications by reverse transcription arrest.
#'  \item[lrt-arrest] TODO
#' }
#' 
#' One major new feature of JACUSA 2.x is the identificaion of RNA modifications by reverse
#' transcription arrest.
#' 
#' When calling RDDs where the RNA-Seq sample has been generated with stranded sequencing library, 
#' base change(s) can be directly inferred and if necessary base calls can be inverted.
#' By default, DNA need to be provided as condition 1 and cDNA as condition 2!
#' Warning: Some function do not support replicates or are exclusively applicable on RDD or RRD 
#' result files!
#' use jacusa2 <- read_result("jacusa2.out") to read JACUSA2 output and
#' \itemize{
#'   \item bc_str1 <- get_bc_str4condition(jacusa, 1) to extract string encoded base call counts for condition 1, or
#'   \item read_str1 <- get_read_str4condition(jacusa, 1) to extract string encoded read start, through, and end counts.
#' }
#' 
#' The central object in Jacusa2Helper is the JACUSA list object that represents
#' JACUSA result file "result.out" and can be created via \code{l <- read_jacusa("result.out")}.
#' 
#' @section input/output functions:
#' The functions read_jacusa, and write_jacusa facilitate input and output operations on JACUSA 1.x and 2.x output files.
#'
#' See:
#' \itemize{
#'   \item read_jacusa
#'   \item write_jacusa
#' }
#'
#' @section get functions:
#' This functions calculate TODO
#'
#' @section add functions:
#' TODO
#' This functions calculate and add additional such as read depth or base call changes. 
#' This includes functions that are encoded as vectors of strings to count vectors or matrices.
#'
#' See:
#' \itemize{
#'   \item add_bc
#'   \item add_bc_change
#'   \item add_bc_change_ratio
#'   \item add_coverage
#' }
#'
#' @section filter functions:
#' This function set enables processing of JACUSA 1.x and 2.x output files such as filtering by read coverage 
#' or enforcing a minimal number of variant base calls per sample.
#'
#' See:
#' \itemize{
#'	 \item filter_allele_count
#'   \item filter_call_stat
#'   \item filter_coverage
#'   \item filter_arrest_stat
#'   \item filter_robust_variants
#'   \item filter_min_variant_count
#' }
#'
#' @docType package
#' @name JACUSA2helper
NULL

# convenience: All possible bases
.BASES <- c("A", "C", "G", "T")
.EMPTY <- "*"
# convenience: DNA "->" RNA 
.BC_CHANGE_SEP <- "->"
.BC_CHANGE_NO_CHANGE <- "no change"

# Helpers defining supported types by JACUSA2.x
.UNKNOWN_METHOD_TYPE <- "unknown"
.CALL_PILEUP_METHOD_TYPE <- "call-pileup"
.RT_ARREST_METHOD_TYPE <- "rt-arrest"
.LRT_ARREST_METHOD_TYPE <- "lrt-arrest"

# convenience: description data fields
.CALL_PILEUP_COLUMN <- "bases"
.RT_ARREST_COLUMN <- "arrest_bases"
.RT_THROUGH_COLUMN <- "through_bases"
.LRT_ARREST_COLUMN <- "arrest_bases"
.LRT_THROUGH_COLUMN <- "through_bases"

# convenience: description info fields
.INFO_COLUMN <- "info"
.FILTER_INFO_COLUMN <- "filter_info"