#' Adds non reference base ratio to JACUSA2 result object.
#' 
#' Given column \emph{ref_base}, calculates \eqn{non-ref. BC ratio = (total BCs - ref. BCs) / total BCs}
#' using \eqn{non-ref. BCs = ref. BCs - total BCs}.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string specifying column prefix. "arrest", "through", or "NULL", default: NULL.
#' @return result object with non reference base substitution ratio added.
#' @examples
#' data(rdd)
#' result <- add_non_ref_ratio(rdd)
#' str(result$non_ref_ratio)
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
#' Retrives non reference ratio based on \code{ref_base} and base calls specified by \code{base_type}.
#' 
#' @param result created by \code{read_result()} or \code{read_results()}.
#' @param base_type string specifying column prefix. "arrest", "through", or "NULL", default: NULL.
#' @return numeric vector of non reference substitution ratios for \code{base_type}.
#' @examples
#' TODO
#' @export
get_non_ref_ratio <- function(result, base_type = "bases") {
  result[[non_ref_ratio_col(base_type)]]
}

#' Calculate non reference ratio from base counts and reference base.
#' 
#' Retrives non reference ratio based on \code{ref_base} and base calls specified by \code{base_type}.
#' 
#' @param ref_base string vector of reference bases.
#' @param bases nx4 matrix or data frame of base call counts.
#' @return numeric vector of non reference substitution ratios for \code{base_type}.
#' @export
non_ref_ratio <- function(ref_base, bases) {
  stopifnot(length(ref_base) ==  nrow(bases))
  n <- length(ref_base)
  
  cov <- rowSums(bases)
  non_zero_i <- cov > 0

  non_ref_ratio <- rep(0.0, n)
  # calculate ratio only for sites with cov > 0 -> x / cov

  # matrix indexing ref base in base call matrix
  ref_base_i <- as.matrix(
    cbind(
      seq_len(n), 
      match(ref_base, BASES)
    )
  )
  # coverage = ref bc + non-ref bc (base_calls[i] corresponds to ref bc)
  non_ref_ratio[non_zero_i] <- (cov[non_zero_i] - as.matrix(bases)[ref_base_i][non_zero_i]) / 
    cov[non_zero_i]

  non_ref_ratio
}

#' Column name for non reference ratio for \code{base_type}.
#' 
#' Column name for non reference ratio for \code{base_type}. 
#' \code{base_type} will be used a suffix to create the column name:
#' "non_ref_ratio[_\code{base_type}]". Using \code{base_type = "bases"} 
#' will result in the field "non_ref_ratio".
#' 
#' @param base_type string TODO
#' @return string the represents the column name for non reference ratio for \code{base_type}.
#' @export
non_ref_ratio_col <- function(base_type) {
  process_col(NON_REF_RATIO, base_type)
}
