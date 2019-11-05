#' Adds non reference base ratio to JACUSA2 result object.
#' 
#' Given column \emph{ref}, calculates \eqn{non-ref. BC ratio = (total BCs - ref. BCs) / total BCs}
#' using \eqn{non-ref. BCs = ref. BCs - total BCs}.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string specifying base column. Default: bases.
#' @return result object with non reference base substitution ratio added.
#' @examples
#' data(rdd)
#' result <- add_non_ref_ratio(rdd)
#' str(result[["non_ref_ratio"]])
#' @export
add_non_ref_ratio <- function(result, base_type = "bases") {
  check_column_exists(result, base_type)
  result[[non_ref_ratio_col(base_type)]] <- non_ref_ratio(
    result[[REF_BASE_COLUMN]], 
    result[[base_type]]
  )
  
  result
}

#' Retrive non reference ratio from a result object.
#' 
#' Retrives non reference ratio based on \code{ref} and base calls specified by \code{base_type}.
#' 
#' @param result created by \code{read_result()} or \code{read_results()}.
#' @param base_type string specifying column prefix. "arrest", "through", or "NULL", default: NULL.
#' @return numeric vector of non reference substitution ratios for \code{base_type}.
#' @examples
#' data(rdd)
#' result <- add_non_ref_ratio(rdd)
#' get_non_ref_ratio(result)
#' @export
get_non_ref_ratio <- function(result, base_type = "bases") {
  result[[non_ref_ratio_col(base_type)]]
}

#' Calculate non reference ratio from base counts and reference base.
#' 
#' Retrives non reference ratio based on \code{ref} and base calls specified by \code{base_type}.
#' 
#' @param ref string vector of reference bases.
#' @param bases nx4 matrix or data frame of base call counts.
#' @return numeric vector of non reference substitution ratios for \code{base_type}.
#' @examples
#' ref <- c("A", "A", "A")
#' bases <- tibble::tribble(
#'   ~A, ~C, ~G, ~T,
#'   10,  0,  5,  5,
#'    0,  1,  1,  1,
#'    1,  1,  1,  1
#' )
#' str(non_ref_ratio(ref, bases))
#' @export
non_ref_ratio <- function(ref, bases) {
  stopifnot(length(ref) ==  nrow(bases))
  n <- length(ref)
  
  cov <- rowSums(bases)
  non_zero_i <- cov > 0

  non_ref_ratio <- rep(0.0, n)
  # calculate ratio only for sites with cov > 0 -> x / cov

  # matrix indexing ref base in base call matrix
  ref_i <- as.matrix(
    cbind(
      seq_len(n), 
      match(ref, BASES)
    )
  )
  # coverage = ref bc + non-ref bc (base_calls[i] corresponds to ref bc)
  non_ref_ratio[non_zero_i] <- (cov[non_zero_i] - as.matrix(bases)[ref_i][non_zero_i]) / 
    cov[non_zero_i]

  non_ref_ratio
}

#' Column name for non reference ratio for \code{base_type}.
#' 
#' Column name for non reference ratio for \code{base_type}. 
#' \code{base_type} will be used to create the column name:
#' \code{non_ref_ratio[_base_type]}. Using \code{base_type = "bases"} 
#' will result in the field \code{non_ref_ratio}.
#' 
#' @param base_type string specifiying base column. Default: bases.
#' @return string the represents the column name for non reference ratio for \code{base_type}.
#' @export
non_ref_ratio_col <- function(base_type) {
  process_col(NON_REF_RATIO, base_type)
}
