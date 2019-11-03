#' Adds base substitution column to JACUSA2 result object.
#' 
#' There must be only one reference base. A->G is okay, but AG->G is NOT allowed! 
#' Make sure to filter \code{result} with \code{filter_by_alleles() TODO} to comply with this restriction.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string specifying column prefix. "arrest", "through", or "NULL", default: NULL.
#' @return result object with base substitutions added.
#' @examples
#' data(rdd)
#' result <- add_base_sub(rdd)
#' str(result[['base_sub']])
#' @export
add_base_sub <- function(result, base_type = "bases") {
  result[[base_sub_col(base_type)]] <- 
    base_sub(
      result[[REF_BASE_COLUMN]], 
      result[[bc_obs_col(base_type)]]
  )
  
  result
}

#' Retrive base substition from a result object.
#'
#' Extracts base substitution for some \code{base_type} from a JACUSA2 result object.. 
#'
#' @param result created by \code{read_result()} or \code{read_results()}.
#' @param base_type string specifying column prefix. "arrest", "through", or "NULL", default: NULL.
#' @return string vector of base substitutions for \code{base_type}.
#' @export
get_base_sub <- function(result, base_type = "bases") {
  result[[base_sub_col(base_type)]]
}

#' Calculates reference base to base call (base substitution).
#' 
#' Calculates and formats base changes for \code{ref_base} and \code{observed_bc}.
#' All elements in \code{ref_bases} must be all length 1.
#' 
#' @param ref_base vector of reference bases.
#' @param bc vector of base calls.
#' @return vector of formatted base call substitutions.
#' @examples
#' ref_base <- c("A", "A", "C", "A")
#' bc <- c("AG", "G", "C", "G")
#' base_sub(ref_base, bc)
#' @export
base_sub <- function(ref_base, bc) {
  if (all(nchar(ref_base) != 1)) {
    stop("All ref_base elements must be nchar() == 1")
  }
  
  # remove ref_base in observed_bc
  # goal: A->G instead of A->AG
  bc <- mapply(function(r, o) {
    return(gsub(r, "", o))
  }, ref_base, bc)
  
  # add nice separator
  base_sub <- paste(ref_base, sep = BC_CHANGE_SEP, bc)
  # add nice info when there is no change
  base_sub[ref_base == bc | bc == ""] <- BC_CHANGE_NO_CHANGE
  
  base_sub
}

#' TODO
#' 
#' TODO
#' 
#' @param base_type TODO
#' @return TODO
#' @examples
#' TODO
#' @export
base_sub_col <- function(base_type = "bases") {
  process_col(BASE_SUB, base_type)
}
