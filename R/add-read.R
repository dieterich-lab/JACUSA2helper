#' Add read start, through, and end counts vector for each condition of a 
#' JACUSA result file.
#'
#' \code{add_read_matrix()} adds read start, through, and end count vector for each 
#' condition of a JACUSA result file to the initial JACUSA list object.  
#'
#' @param jacusa List object created by \code{read_jacusa}.
#' @param read_str1 Vector or list of vectors of string encoding read start, 
#' through, and end counts for condtition 1.
#' @param read_str2 Vector or list of vectors of string encoding read start, 
#' through, and end counts for condtition 2.
#' 
#' @return Returns a JACUSA list object with additional "read_matrix1" and 
#' "read_matrix2" fields.
#'
#' @export 
add_read_matrix <- function(jacusa, 
                            read_str1 = get_read_str4condition(jacusa, 1),
                            read_str2 = get_read_str4condition(jacusa, 2)) {
  jacusa[["read_matrix1"]] <- read_str2read_matrix(read_str1)
  jacusa[["read_matrix2"]] <- read_str2read_matrix(read_str2)
  jacusa
}
