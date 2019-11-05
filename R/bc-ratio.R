#' Adds base call ratio.
#' 
#' Calculates and adds base call ratio for all possible bases.
#' For a given \code{base_type}, calculates a base ratio vector \code{bc_ratio[_base_type]} 
#' for all possible bases (A, C, G, and T).
#' 
#' @param result created by \code{read_result()} or \code{read_results()}.
#' @param base_type string specifying base column. Default: bases.
#' @return result object with base call ratio added.
#' @examples
#' data(rdd)
#' # use default bases to define ratio
#' result <- add_bc_ratio(rdd)
#' str(subset(result, select = grep("bc_ratio", names(result))))
#' 
#' data(HIVRT)
#' # use arrest bases
#' result <- add_bc_ratio(HIVRT, "arrest")
#' subset(result, select = grep("bc_ratio_arrest", names(result)))
#' @export 
add_bc_ratio <- function(result, base_type = "bases") {
  check_column_exists(result, base_type)
  result[[bc_ratio_col(base_type)]] <- bc_ratio(result[[base_type]])
  
  result
}

#' Retrive base call ratio from a result object.
#'
#' Extracts base call ratio for some \code{base_type} from a JACUSA2 result object.
#'
#' @param result created by \code{read_result()} or \code{read_results()}.
#' @param base_type string specifying base column. Default: bases.
#' @return numeric tibble of base call ratios for \code{base_type}.
#' @examples
#' data(rdd)
#' # use default bases to define ratio
#' ratio <- get_bc_ratio(rdd)
#' str(ratio)
#' 
#' data(HIVRT)
#' # use arrest bases to define ratio
#' ratio <- get_bc_ratio(rdd, "arrest")
#' str(ratio)
#' @export
get_bc_ratio <- function(result, base_type = "bases") {
  result[[bc_ratio_col(base_type)]]
}

#' Calculate base call ratios for base counts.
#' 
#' Calculates base call ratios for base counts. 
#' \code{bases} is expected to be a nx4 matrix or data frame.
#' 
#' @param bases nx4 matrix or data frame of base call counts.
#' @return data frame of base call rations \code{bases}.
#' @examples
#' bases <- matrix(c(5, 0, 5, 0,  1, 1, 1, 1), byrow = TRUE, ncol = 4)
#' ratio <- bc_ratio(bases)
#' @export
bc_ratio <- function(bases) {
  total <- rowSums(bases)
  
  m <- matrix(
    0.0, 
    nrow = nrow(bases), 
    ncol = length(BASES)
  ) 
  colnames(m) <- BASES
  df <- tibble::as_tibble(m)

  # calculate ratio only for sites with cov > 0 -> x / cov
  non_zero_i <- total > 0
  df[non_zero_i, ] <- bases[non_zero_i, ] / total[non_zero_i]
  
  df
}

#' Column name for base call ratios for \code{base_type}.
#' 
#' Column name for base call ratios for \code{base_type}. 
#' \code{base_type} will be used to create the column name:
#' \code{bc_ratio[_base_type]}. Using \code{base_type = "bases"} 
#' will result in the field "bc_ratio".
#' 
#' @param base_type string specifiying base column. Default: bases.
#' @return string that represents the column name for base call ratios for \code{base_type}.
#' @export
bc_ratio_col <- function(base_type = "bases") {
  process_col(BC_RATIO, base_type)
}
