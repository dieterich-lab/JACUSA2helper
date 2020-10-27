#' Calculate non reference ratio from base counts and reference base.
#' 
#' Retrieves non reference ratio based on \code{ref} and base calls given by \code{bases}.
#' 
#' @param ref string vector of reference bases.
#' @param bases nx4 matrix or data frame of base call counts.
#' @return numeric vector of non reference substitution ratios for \code{bases}.
#' @examples
#' ref <- c("A", "A", "A")
#' bases <- tidyr::tribble(
#'   ~A, ~C, ~G, ~T,
#'   10,  0,  5,  5,
#'    0,  1,  1,  1,
#'    1,  1,  1,  1
#' )
#' non_ref_ratio(bases, ref)
#' @export
non_ref_ratio <- function(bases, ref) {
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
      match(ref, .BASES)
    )
  )
  # coverage = ref bc + non-ref bc (base_calls[i] corresponds to ref bc)
  non_ref_ratio[non_zero_i] <- (cov[non_zero_i] - as.matrix(bases)[ref_i][non_zero_i]) / 
    cov[non_zero_i]

  non_ref_ratio
}
