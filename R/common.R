#' Jacusa2Helper: A package for post-processing JACUSA 1.x and 2.x result files.
#'
#' The Jacusa2Helper package provides the following categories of important functions:
#' input/output, get, add, and filter to post-process result files of JACUSA 2.x.
#' 
#' \itemize{
#'  \item[call{1,2}]  calling variants from one condition or condition comparisons.
#'  \item[rt-arrest] identificaion of RNA modifications by reverse transcription arrest.
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
#' use jacusa <- read_jacusa("jacusa.out") to read JACUS output and
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
#'   \item add_read
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
#'   \item filter_rt_arrest_stat
#'   \item filter_robust_variants
#'   \item filter_min_variant_count
#' }
#'
#' @docType package
#' @name JacusaHelper
NULL

# convenience: All possible bases
.BASES <- c("A", "C", "G", "T")
# convenience: description of RT arrest fields
.READ <- c("start", "through", "end")
.RT <- c("arrest", "through")

# convenience: A -> G
.BC_CHANGE_SEP <- "->"
.BC_CHANGE_NO_CHANGE <- "no change"

#' Calculates the fraction of editing sites among RDDs in JACUSA result file.
#'
#' \code{score_bc_change()} calculates the fraction of editing sites among RDDs in JACUSA result file.
#' 
#' @param bc_change_tbl Vector object created by \code{table()}.
#' @param bc_change String that identifies true editing, e.g.: "A->G". Use: \code{format_bc_change()}
#' 
#' @return Returns a numeric value that represent the fraction of editing sites among RDDs.
#'
#' @examples
#' ## add fields automatically
#' jacusa <- add_bc_change(rdd, aa = TRUE)
#' bc_change_tbl <- table(jacusa$bc_change)
#' score_bc_change(bc_change_tbl)
#' 
#' @export 
score_bc_change <- function(bc_change_tbl, bc_change = format_bc_change("A", "G")) {
	total <- sum(bc_change_tbl)
	tp <- sum(bc_change_tbl[bc_change])
	return(tp / total)
}

#' Get complemenarty base call count matrix.
#'
#' Get complemenarty base call count matrix.
#'
#' @param bc_matrix Matrix of base call counts.
#'
#' @return Returns complementary base call matrix.
#'
#' @export
get_comp_bc_matrix <- function(bc_matrix) {
	tmp <- bc_matrix 
	tmp[, "A"] <- bc_matrix[, "T"]
	tmp[, "C"] <- bc_matrix[, "G"]
	tmp[, "G"] <- bc_matrix[, "C"]
	tmp[, "T"] <- bc_matrix[, "A"]
	tmp
}

#' Invert vector of base calls.
#'
#' Inverts vector of base calls.
#'
#' @param bcs List of vectors of base calls.
#'
#' @return Returns a List of vector of complementary base calls.
#'
#' @export
get_comp_bcs <- function(bcs) {
  comp_BASES <- rev(.BASES)

  lapply(bcs, function(x) {
    i <- match(x, .BASES)
    comp_BASES[i]
  })
}

#' Calculate false discovery rate (FDR) based on observed base call changes and 
#' expected base call changes. 
#'
#' Calculate false discovery rate (FDR) based on observed base call changes and 
#' expected base call changes. 
#'
#' @param bc_change_tbl Vector object created by \code{table()}.
#' @param expected String that represents the expected base call change.
#'
#' @return Returns the calculate FDR.
#'
#' @export
get_false_discovery_rate <- function(bc_change_tbl, expected = format_bc_change("A", "G")) {
	fdr <- 1 - score_bc_change(bc_change_tbl, expected)
	fdr
}

#' Format base call change between two conditions.
#'
#' Formats base call change (e.g.: RNA editing) for two base call vectors.
#'
#' @param bc1 Vector of base calls for condition 1.
#' @param bc2 Vector of base calls for condition 2.
#' @param sep String: "bc1"sep"bc2".
#' 
#' @return Vector of base call changes between condition 1 and 2.
#'
#' @export
format_bc_change <- function(bc1, bc2, sep = .BC_CHANGE_SEP) {
	d <- paste(bc1, sep = sep, bc2)
	d[d == sep] <- .BC_CHANGE_NO_CHANGE
  d
}

#' Plot the distribution of base changes.
#'
#' Plot the distribution of base changes.
#'
#' @param bc_change_tbl Table object created by \code{table()}.
#' @param bc_change Base call change between condition 1 and 2 to score for.
#'
#' @export
plot_bc_change_table <- function(bc_change_tbl, 
                                 bc_change = format_bc_change("A", "G")) {
	main <- ""
	if (! is.null(bc_change)) {
		score <- score_bc_change(bc_change_tbl, bc_change)
		main <- paste(bc_change, " (", format(score * 100, digits = 4), "%)", sep = "")  
	}
	barplot(bc_change_tbl, las = 2, main = main, ylab = "Frequency")
}
