#' Add base call count matrix to JACUSA list object.
#'
#' \code{add_bc_matrix()} adds base call count matrix for both 
#' conditions to JACUSA list object. JACUSA list object must have the following 
#' fields set: "bases1*" and "bases2*". Each "basesij" field, where i = condition 
#' and j respective replicate number, encodes base call counts (A,C,G,T) that are 
#' separated by ",": 10,2,0,0
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' @param bc_str1 Vector or list of string vectors that encode base calls for 
#' condition 1.
#' @param bc_str2 Vector or list of string vectors that encode base calls for 
#' condition 2.
#' 
#' @return Returns a JACUSA list object with "bc_matrix1" and "bc_matrix2" fields 
#' that contain the respective base call count matrix.
#' 
#' @export
add_bc_matrix <- function(jacusa, 
                          bc_str1 = get_bc_str4condition(jacusa, 1), 
                          bc_str2 = get_bc_str4condition(jacusa, 2)) {
  jacusa$bc_matrix1 <- bc_str2bc_matrix(bc_str1)
  jacusa$bc_matrix2 <- bc_str2bc_matrix(bc_str2)
  jacusa
}

#' Add string vector of observed base calls for each condition to JACUSA list 
#' object.
#'
#' \code{add_bc()} calculates a vector of observed base calls for each condition 
#' and adds "bc1" and "bc2" fields to the JACUSA list object. 
#' Make sure \code{add_bc_matrix()} has been called to populate "bc_matrix1" 
#' and "bc_matrix2" fields or set option "aa" (i.e. auto_add) to TRUE.
#' All necessary but missing fields will be added automatically, possibly 
#' overriden existing fields of the JACUSA list object.
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' @param bc_matrix1 Base call matrix of list of base call matrices for 
#' condition 1.
#' @param bc_matrix2 Base call matrix of list of base call matrices for 
#' condition 2.
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
add_bc <- function(jacusa, 
                   bc_matrix1 = jacusa$bc_matrix1, 
                   bc_matrix2 = jacusa$bc_matrix2,
                   aa = FALSE) {
  # auto add missing fields
  if (aa) {
    jacusa <- add_bc_matrix(jacusa)
    bc_matrix1 = jacusa$bc_matrix1 
    bc_matrix2 = jacusa$bc_matrix2
  }
  jacusa$bc1 = get_bc(bc_matrix1)
  jacusa$bc2 = get_bc(bc_matrix2)
  jacusa
}

#' Add base call change for RDD comparisons of a JACUSA result file.
#'
#' \code{add_bc_change()} adds base call changes for gDNA vs. cDNA comparisons.
#' Make sure \code{add_bc()} has been called to populate "bc1" and "bc2" fields or 
#' set option "aa" (i.e. auto_add) to TRUE.
#' All necessary but missing fields will be added automatically, possibly 
#' overriden existing fields of the JACUSA list object.
#'
#' @param jacusa List object created by \code{read_jacusa()}.
#' @param bc1 Vector of observed base calls for condition 1.
#' @param bc2 Vector of observed base calls for condition 2.
#' @param aa Logical indicates if missing fields should added automatically.
#'
#' @return Returns a JACUSA object list with the additional "bc_change" field.
#'
#' @examples
#' ## populate necessary fields manually
#' jacusa <- add_bc_matrix(rdd)
#' jacusa <- add_bc(jacusa)
#' jacusa <- add_bc_change(jacusa)
#' ## plot distribution of base changes
#' barplot(table(jacusa$bc_change))
#'
#' ## populate necessary fields automatically
#' jacusa <- add_bc_change(jacusa, aa = TRUE)
#' ## plot distribution of base changes
#' barplot(table(jacusa$bc_change))
#' 
#' @export 
add_bc_change <- function(jacusa, 
                          bc1 = jacusa$bc1,
                          bc2 = jacusa$bc2,
                          aa = FALSE) {
  # auto add missing fields
  if (aa) {
    jacusa <- add_bc(jacusa, aa = TRUE)
    bc1 = jacusa$bc1
    bc2 = jacusa$bc2
  }
  jacusa[["bc_change"]] <- get_bc_change(bc1, bc2)
  jacusa
}

#' Add base call change ratio (e.g.: editing frequency) to a JACUSA object list.
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
add_bc_change_ratio <- function(jacusa, 
                                bc1 = jacusa$bc1, 
                                bc2 = jacusa$bc2, bc_matrix2 = jacusa$bc_matrix2, 
                                aa = FALSE) {
  # auto add missing fields
  if (aa) {
    jacusa <- add_bc_change(jacusa, aa = TRUE)
    bc1 = jacusa$bc1
    bc2 = jacusa$bc2
    bc_matrix2 = jacusa$bc_matrix2
  }
  jacusa <- c(jacusa, get_bc_change_ratio(bc1, bc2, bc_matrix2))
  jacusa
}
