#' JACUSA2helper: A package for post-processing JACUSA2 result files.
#'
#' The JACUSA2helper package provides the following categories of functions to 
#' post-process result files of JACUSA2:
#' \itemize{
#'  \item[read/write] Read and write JACUSA2 result files.
#'  \item[add] This will add some field to an existing JACUSA2 result object and return the modified object.
#'  \item[check] This will perform some checks on result objects
#'  \item[filter] This will remove sites from a result object with some filtering criteria.
#'  \item[get] TODO
#' }
#' 
#' The following methods are supported:
#' \itemize{
#'  \item[call{1,2}] calling variants from one condition or a comparison of conditions.
#'  \item[pileup] SAMtools like pileup
#'  \item[rt-arrest] identification transcription arrest events.
#'  \item[lrt-arrest] combination of varidant discovery and read arrest events. 
#' }
#' 
#' One major new feature of JACUSA 2.x is the identificaion of read arrest events.
#' TODO tidy data, dplyr
#' 
#' When working with stranded RNA-Seq data, inverting base calls is not necessary because
#' JACUSA2 will automatically invert Single End and Paired End depending on the provided 
#' library type option "-P" UNSTRANDED|FR_FIRSTSTRAND|RF_SECOND_STRAND".
#' 
#' The central data structure in JACUSA2helper is the JACUSA2 result object that follows the 
#' tidy data approach to feature easy interplay with dplyr and ggplot2.
#' An JACUSA2 result object can be created via \code{result <- read_result("jacusa2.out")} and is 
#' currently represented as a data.frame.
#' 
#' @section read/write functions:
#' The functions read_result, and write_result facilitate input and output operations on JACUSA2 
#' result files.
#'
#' See:
#' \itemize{
#'   \item read_result
#'   \item write_result
#' }
#'
#' @section add functions:
#' TODO
#' 
#' See:
#' \itemize{
#'   \item add_coverage
#'   \item add_ref_base2bc
#'   \item add_ref_base2bc_ratio
#' }
#'
#' @section check functions:
#' TODO
#'
#' See:
#' \itemize{
#'   \item check_max_alleles
#' }
#'
#' @section filter functions:
#' This function set enables filtering by read coverage or 
#' enforcing a minimal number of variant base calls per sample.
#'
#' See:
#' \itemize{
#'	 \item filter_by_allele_count
#'   \item filter_by_coverage
#'   \item filter_robust_variants
#'   \item filter_by_min_score
#'   \item filter_by_max_score
#' }
#'
#' #' @section get functions:
#' TODO
#'
#' See:
#' \itemize{
#'   \item get_bc_change
#'   \item get_bc_change_ratio
#'   \item get_variant_count
#' }
#'
#' @docType package
#' @name JACUSA2helper
NULL