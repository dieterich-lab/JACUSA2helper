#' Subset of RDDs detected by JACUSA in HEK-293 untreated cells
#'
#' A dataset containing a subset of RNA DNA differences (RDDs) identified by JACUSA in untreated HEK-293 cells. 
#' The fields are as follows:
#'
#' @format a list with 11 elements where each has 10,000 elements on its on.
#' \itemize{
#'		\item contig: contig
#'		\item start: position of variant (>=0)
#'		\item end: start + 1 (conform to BED file format)
#'		\item name: arbitrary (conform to BED file format)
#'		\item stat: higher value of test-statistic indicate more divergent pileups
#'		\item strand: "+", "-", "." (no strand available)
#'		\item bases11: Base count for genomic DNA (A, C, G, T)
#'		\item bases21: Base count for RNA replicate 1
#'		\item bases22: Base count for RNA replicate 2
#'		\item info: Additional info for this specific site. Empty field is equal to "*"
#'		\item filter_info: comma-separated list of feature filters Empty field is equal equal "*"
#' }
"rdd"

#' Subset of RRDs detected by JACUSA in HEK-293 ADAR KD and untreated cells
#'
#' A dataset containing a subset of RNA RNA differences (RRDs) identified by JACUSA in ADAR KD and untreated HEK-293 cells. 
#' The fields are as follows:
#'
#' @format a list with 11 elements where each has 10,000 elements on its on.
#' \itemize{
#'		\item contig: contig
#'		\item start: position of variant (>=0)
#'		\item end: start + 1 (conform to BED file format)
#'		\item name: arbitrary (conform to BED file format)
#'		\item stat: higher value of test-statistic indicate more divergent pileups
#'		\item strand: "+", "-", "." (no strand available)
#'		\item bases11: Base count for ADAR KD replicate 1 (A, C, G, T)
#'		\item bases12: Base count for ADAR KD replicate 2
#'		\item bases21: Base count for untreated RNA replicate 1
#'		\item bases22: Base count for untreated RNA replicate 2
#'		\item info: Additional info for this specific site. Empty field is equal to "*"
#'		\item filter_info: comma-separated list of feature filters Empty field is equal equal "*"
#' }
"rrd"

##' TODO
##'
##' TODO
##' The fields are as follows:
##'
##' @format a list with 11 elements where each has 10,000 elements on its on.
##' \itemize{
##'  	\item contig: contig
##'		\item start: position of variant (>=0)
##'		\item end: start + 1 (conform to BED file format)
##'		\item name: arbitrary (conform to BED file format)
##'		\item stat: pvalue TODO
##'		\item strand: "+", "-", "." (no strand available)
##'		\item bases11: Base count (A, C, G, T) for condition 1 and replicate 1 
##'  	\item reads11: Read info count (read start, through, end) for condition 1 and replicate 1
##'  	\item bases12: Base count cond. 1 and rep. 2
##'    \item reads12: Read info count for condition 1 and replicate 1
##'    \item bases13: Base count cond. 1 and rep. 3
##'    \item reads13: Read info count for condition 1 and replicate 3
##'		\item bases21: Base count cond. 2 and rep. 1
##'    \item reads21: Read info count for condition 2 and replicate 3
##'		\item bases22: Base count cond. 2 and rep. 2
##'    \item reads22: Read info count for condition 2 and replicate 2
##'  	\item bases23: Base count cond. 2 and rep. 3
##'    \item reads23: Read info count for condition 2 and replicate 3
##'		\item info: Additional info for this specific site. Empty field is equal to "*"
##'		\item filter_info: comma-separated list of feature filters Empty field is equal equal "*"
##' }
#"rt_arrest"