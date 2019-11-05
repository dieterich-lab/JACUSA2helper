#' Add base substitution.
#' 
#' Adds base substitution column to a JACUSA2 result object.
#' There must be only one reference base. A->G is okay, but AG->G is NOT allowed! 
#' Make sure to filter \code{result} with \code{filter_by_alleles() TODO} to comply with this restriction.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining the column to use as base counts. Default: bases.
#' @return result object with base substitutions added.
#' @examples
#' data(rdd)
#' result <- add_sub(rdd)
#' str(result[["base_sub"]])
#' @export
add_sub <- function(result, base_type = "bases") {
  check_column_exists(result, bc_col(base_type))
  
  result[[sub_col(base_type)]] <- 
    base_sub(
      result[[REF_BASE_COLUMN]], 
      result[[bc_col(base_type)]]
  )
  
  result
}

#' Retrive base substition from a result object.
#'
#' Extracts base substitution for some \code{base_type} from a JACUSA2 result object.. 
#'
#' @param result created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining the column to use as base counts. Default: bases.
#' @return string vector of base substitutions for \code{base_type}.
#' @examples
#' data(rdd)
#' result <- add_sub(rdd)
#' str(get_sub(result))
#' @export
get_sub <- function(result, base_type = "bases") {
  result[[sub_col(base_type)]]
}

#' Calculates reference base to base call (base substitution).
#' 
#' Calculates and formats base changes for \code{ref} and \code{bc}.
#' All elements in \code{ref} must be all length 1.
#' 
#' @param ref vector of reference bases.
#' @param bc vector of base calls.
#' @return vector of formatted base call substitutions.
#' @examples
#' ref <- c("A", "A", "C", "A")
#' bc <- c("AG", "G", "C", "G")
#' base_sub(ref, bc)
#' @export
base_sub <- function(ref, bc) {
  if (all(nchar(ref) != 1)) {
    stop("All ref elements must be nchar() == 1")
  }
  
  # remove ref in bc
  # goal: A->G instead of A->AG
  bc <- mapply(function(r, o) {
    return(gsub(r, "", o))
  }, ref, bc)
  
  # add nice separator
  base_sub <- paste(ref, sep = BC_CHANGE_SEP, bc)
  # add nice info when there is no change
  base_sub[ref == bc | bc == ""] <- BC_CHANGE_NO_CHANGE
  
  base_sub
}

#' Column name for base substitution for \code{base_type}.
#' 
#' Column name for base substitution for \code{base_type}. 
#' \code{base_type} will be used to create the column name:
#' \code{sub[_base_type]}.
#' 
#' @param base_type string defining the column to use as base counts. Default: bases.
#' @return string the represents the column name for base substition for \code{base_type}.
#' @export
sub_col <- function(base_type = "bases") {
  process_col(BASE_SUB, base_type)
}
