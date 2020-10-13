#' Calculate base call ratios for base counts.
#' 
#' Calculates base call ratios for base counts. 
#' \code{bases} is expected to be a nx4 matrix or data frame.
#' 
#' @param bases nx4 matrix or data frame of base call counts.
#' @return data frame of base call rations \code{bases}.
#' @examples
#' bases <- matrix(c(5, 0, 5, 0,  1, 1, 1, 1), byrow = TRUE, ncol = 4)
#' ratio <- base_ratio(bases)
#' @export
base_ratio <- function(bases) {
  total <- rowSums(bases)
  
  m <- matrix(
    0.0, 
    nrow = nrow(bases), 
    ncol = length(.BASES)
  ) 
  colnames(m) <- .BASES
  df <- tidyr::as_tibble(m)

  # calculate ratio only for sites with cov > 0 -> x / cov
  non_zero_i <- total > 0
  df[non_zero_i, ] <- bases[non_zero_i, ] / total[non_zero_i]
  
  df
}
