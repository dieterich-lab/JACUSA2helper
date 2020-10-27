#' JACUSA2helper: A package for post-processing JACUSA2 result files.
#'
#' TODO
#'
#' @section Description:
#' A package that provides functions to post-process result files of JACUSA2.
#' 
#' The following methods from JACUSA2 are supported:
#' \describe{
#'  \item{call{1,2}}{calling variants from one condition or a comparison of conditions.}
#'  \item{pileup}{SAMtools like pileup.}
#'  \item{rt-arrest}{identification of transcription arrest events.}
#'  \item{lrt-arrest}{combination of variant discovery and read arrest events.}
#' }
#' 
#' One major new feature of JACUSA2 is the identification of read arrest events. 
#' In this method, the vector of base call is partitioned into read arrest and read through bases.
#' 
#' When working with stranded RNA-Seq data, inverting base calls is not necessary because
#' JACUSA2 will automatically invert Single End (SE) and Paired End (PE) depending on the
#' provided library type option "-P" UNSTRANDED|FR_FIRSTSTRAND|RF_SECOND_STRAND".
#' 
#' The central data structure in JACUSA2helper is the JACUSA2 result object that follows the 
#' tidy data approach to feature easy interaction with dplyr and ggplot2.
#' A JACUSA2 result object can be created via \code{result <- read_result("jacusa2.out")} and is 
#' currently represented as a tibble. Special structured columns exist that 
#' hold condition andn replicate related data such as: coverage, bases. arrest rate.
#' Furthermore, JACUSA2helper supports the analysis of several related  JACUSA2 
#' result files via \code{results <- read_results(files, meta_cond)} where 
#' \code{meta_cond} is a vector of character strings that provides a descriptive 
#' name for each file in \code{files}.
#' 
#' Check \code{vignette("JACUSA2helper", "JACUSA2helper")} for a general 
#' introduction and \code{"JACUSA2helper", "JACUSA2helper"} for details about 
#' meta conditions.
#' 
#' @section read/write functions:
#' See:
#' \describe{
#'   \item{read_result}{Reads and unpacks a JACUSA2 result file.}
#'   \item{read_results}{Allows to combine multiple result files and distinguish them with meta conditions.}
#   \item{write_result}{This will pack result object and write its contents back to a file.}
#'   \item{write_bedGraph}{Writes a vector of values as bedGraph file.}
#' }
#'
#' @section Helper functions:
#' See:
#' \describe{
#'   \item{arrest_rate}{Calculates arrest rate from base call counts (arest, through).}
#'   \item{base_count}{Calculates the bumber of observed base calls.}
#'   \item{base_sub}{Calculates base substitution.}
#'   \item{base_ratio}{Calculates base call ratios.}
#'   \item{non_ref_ratio}{Calculates non reference base ratio to JACUSA2 result object.}
#'   \item{sub_ratio}{Calculates base substitution ratio for all bases to a JACUSA2 result object.}
#'
#   \item{merge_sub}
#   \item{mask_sub}
#' }
#'
#' @section filter functions:
#' This function set enables filtering by read coverage or enforcing a minimal 
#' number of variant base calls per sample.
#'
#' See:
#' \describe{
#'   \item{robust}{Retains sites that are robust in one feature. The feature can be observed in all replicates of at least one condition.}
#'   \item{filter_artefact}{Remove sites that have been marked as an artefact.}
#'	 \item{All}{Helper function}
#'	 \item{Any}{Helper function}
#'	 \item{lapply_cond}{lapply wrapper - applies function to all conditions.}
#'	 \item{lapply_repl}{lapply wrapper - applies function to all replicates.}
#'	 \item{mapply_repl}{mapply wrapper - applies function to all replicates.}
#' }
#'
#' @docType package
#' @name JACUSA2helper
NULL
