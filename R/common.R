#' JACUSA2helper: A package for post-processing JACUSA2 result files.
#'
#' @section Description:
#' A package that provides the following categories of functions to post-process result files of JACUSA2:
#' \describe{
#'  \item{read/write}{Read and write JACUSA2 result files, e.g.: \code{read_result()}.}
#'  \item{add}{Adds some field to an existing JACUSA2 result object and return the modified object, e.g.: \code{base_sub()}.}
#'  \item{filter}{Will remove sites from a result object with some filtering criteria, e.g.: \code{filter_by_coverage()}}
#'  \item{plot}{Plots certain characteristics of a JACUSA2 result object.}
#'  \item{other}{TODO}
#' }
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
#' currently represented as a tibble. Furthermore, JACUSA2helper supports the analysis of several related
#' JACUSA2 result files via \code{results <- read_results(files, meta)} where \code{meta_conditions} is a 
#' vector of character strings that provides a descriptive name for each file in \code{files}.
#' 
#' Check \code{vignette(TODO)} for a general introduction and \code{vignette(TODO meta conditions)} for details about meta conditions.
#' 
#' @section read/write functions:
#' See:
#' \describe{
#'   \item{read_result}{Reads and unpacks a JACUSA2 result file and creates a result object.}
#'   \item{read_results}{Allows to combine multiple result files and distinguish them with meta conditions.}
#   \item{write_result}{This will pack result object and write its contents back to a file.}
#'   \item{write_bedGraph}{Writes a vector of values as bedGraph file.}
#' }
#'
#' @section Helper functions:
#' See:
#' \describe{
#'   \item{arrest_rate}{Adds arrest rate to JACUSA2 result object.}
#'   \item{base_count}{TODO}
#'   \item{base_sub}{Adds base substitution column to JACUSA2 result object.}
#'   \item{non_ref2bc_ratio}{Adds non reference base ratio to JACUSA2 result object.}
#'   \item{sub_ratio}{Adds base substitution ratio for all bases to a JACUSA2 result object.}
#' }
#'
#' @section filter functions:
#' This function set enables filtering by read coverage or 
#' enforcing a minimal number of variant base calls per sample.
#'
#' See:
#' \describe{
#'   \item{robust}{Retains sites that contain an arrest event in all replicates in at least one condition.}
#'	 \item{All}{TODO}
#'	 \item{Any}{TODO}
#' }
#'
#' # TODO
#' read_sub
#'
#' @docType package
#' @name JACUSA2helper
NULL

