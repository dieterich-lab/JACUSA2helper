# TODO 
# * finish this
# * adjust read_result
# * adjust test(s)

#' Add base call count matrix to JACUSA2 list object.
#'
#' \code{add_bc_matrix()} adds base call count matrix for arbitrary number 
#' of conditions to JACUSA2 list object. List object must have the following 
#' field: "base_str[[i]][[j]]" where i = condition and j respective replicate number, 
#' encodes base call counts (A,C,G,T) that are separated by ",": 10,2,0,0
#'
#' @param jacusa2 List object created by \code{read_result()}.
#' 
#' @return Returns a JACUSA2 list object with "bc_matrix[[condition]][replicate]]" field 
#' that contains the respective base call count matrix.
#' 
#' @export
add_bc_matrix <- function(jacusa2) {
  # TODO how many conditions
  conditions <- "TODO"
  
  # OLD
  # jacusa2$bc_matrix1 <- bc_str2bc_matrix(bc_str1)
  # jacusa2$bc_matrix2 <- bc_str2bc_matrix(bc_str2)
  # TODO jacusa$bc_matrix[1,2]
  jacusa2
}

#' Add string vector of observed base calls for each condition to JACUSA2 list 
#' object.
#'
#' \code{add_bc()} calculates a vector of observed base calls for each condition 
#' and adds "bc[[condition]][replicate]] field to the JACUSA2 list object. 
#' Make sure \code{add_bc_matrix()} has been called to populate "bc_matrix" or 
#' set option "aa" (i.e. auto_add) to TRUE.
#' All necessary but missing fields will be added automatically, possibly 
#' overriden existing fields.
#'
#' @param jacusa2 List object created by \code{read_result()}.
#' @param bc_matrix List of Base call matrix lists.
#' @param aa Logical indicates if missing fields should added automatically.
#' 
#' @return Returns a JACUSA list object with additional Base call (BC) fields: 
#' "bc1" and "bc2".
#'
#' @examples
#' ## add fields manually
#' jacusa <- add_bc_matrix(rdd)
#' jacusa <- add_bc(jacusa)
#' ## plot distribution of base calls in condition1
#' barplot(table(jacusa$bc1))
#' 
#' ## add missing fields automatically
#' jacusa <- add_bc(jacusa, aa = TRUE)
#' barplot(table(jacusa$bc1))
#' 
#' @export 
add_bc <- function(jacusa2, bc_matrix = jacusa2$bc_matrix, aa = FALSE) {
  # auto add missing fields
  if (aa) {
    jacusa2 <- add_bc_matrix(jacusa2)
    bc_matrix2 = jacusa$bc_matrix 
  }
  # TODO
  jacusa2$bc = get_bc(bc_matrix)
  jacusa2
}

# TODO make call-1 possible, how to deal with RRD?
#' Add base call change for RDD comparisons of a JACUSA2 result file.
#'
#' \code{add_bc_change()} adds base call changes for gDNA vs. cDNA comparisons.
#' Make sure \code{add_bc()} has been called to populate "bc1" and "bc2" fields or 
#' set option "aa" (i.e. auto_add) to TRUE.
#' All necessary but missing fields will be added automatically, possibly 
#' overriden existing fields of the JACUSA list object.
#'
#' @param jacusa2 List object created by \code{read_jacusa()}.
#' @param ref TODO 0 => use ref_base > 0 => condition in bc
#' @param bc List of Vector of observed base calls.
#' @param aa Logical indicates if missing fields should added automatically.
#'
#' @return Returns a JACUSA object list with the additional "bc_change" field.
#'
#' @examples
#' ## populate necessary fields manually
#' jacusa2 <- add_bc_matrix(rdd)
#' jacusa2 <- add_bc(jacusa2)
#' jacusa2 <- add_bc_change(jacusa2)
#' ## plot distribution of base changes
#' barplot(table(jacusa2$bc_change))
#'
#' ## populate necessary fields automatically
#' jacusa2 <- add_bc_change(jacusa2, ref = 1, aa = TRUE)
#' ## plot distribution of base changes
#' barplot(table(jacusa2$bc_change))
#' 
#' @export 
add_bc_change <- function(jacusa2, 
                          ref = 0,
                          bc = jacusa2$bc,
                          aa = FALSE) {
  # auto add missing fields
  if (aa) {
    jacusa2 <- add_bc(jacusa2, aa = TRUE)
    bc = jacusa2$bc
  }
  if (ref > 0) {
    dna <- bc[[ref]]
  } else {
    dna <- jacusa2$ref_base
  }
  jacusa2$bc_change <- get_bc_change(dna, rna)
  jacusa2
}

#' Add base call change ratio (e.g.: editing frequency) to a JACUSA2 object list.
#'
#' \code{add_bc_change_ratio()} adds base call change ratio (e.g.: editing frequency) 
#' for each replicate and an average over all replictes for gDNA vs. cDNA comparisons
#' to the JACUSA list object. Condition 2 is be cDNA data. 
#' Depending on the number (=n2) of replicates in condition 2, n2 + 1 fields are added:
#' \itemize{
#'  \item bc_change_ratio1 - base call change ratio of condition 1 vs. replicate 1 
#'  of condition 2
#'  \item ... - ...
#'  \item bc_change_ratio{n2} - base call change ratio of condition 1 vs. replicate n2
#'  of condition 2
#'  \item bc_change_ratio - average over bc_change_ratio{1, ..., n2}
#' }
#' 
#' @param jacusa List object created by \code{read_jacusa()}.
#' @param bc1 Vector of observed base calls for condition 1.
#' @param bc2 Vector of observed base calls for condition 2.
#' @param bc_matrix2 Base call matrix of list of base call matrices for condition 2.
#' @param aa Logical indicates if missing fields should added automatically.
#' 
#' @return Returns a JACUSA list object the additional fields: "bc_change_ratio", 
#' "bc_change_ratio1", ... "bc_change_ratio{n2}", where n2 is the number of replicates 
#' of condition 2.
#'
#' @examples
#' ## add fields manually
#' jacusa <- add_bc_matrix(rdd)
#' jacusa <- add_bc(jacusa)
#' jacusa <- add_bc_change(jacusa)
#' jacusa <- add_bc_change_ratio(jacusa)
#' ## plot a boxplot of editing frequencies for each base change
#' boxplot(tapply(jacusa$bc_change_ratio, jacusa$bc_change, c))
#' 
#' #' ## add fields automatically
#' jacusa <- add_bc_change_ratio(rdd, aa = TRUE)
#' ## plot a boxplot of editing frequencies for each base change
#' boxplot(tapply(jacusa$bc_change_ratio, jacusa$bc_change, c))
#' 
#' @export 
add_bc_change_ratio <- function(jacusa2, 
                                ref,
                                bc = jacusa2$bc, 
                                bc_matrix = jacusa2$bc_matrix, 
                                aa = FALSE) {
  # auto add missing fields
  # TODO
  if (aa) {
    jacusa2 <- add_bc_change(jacusa2, aa = TRUE)
    bc <- jacusa$bc
    bc_matrix <- jacusa$bc_matrix
  }
  # TODO
  jacusa2 <- c(jacusa2, get_bc_change_ratio(bc, bc_matrix))
  jacusa2
}
