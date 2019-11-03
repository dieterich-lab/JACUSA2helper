#' Add base substitution ratio
#' 
#' Adds ratio for base substitution defined by "ref_base" column and base counts 
#' given by \code{base_type}. It is required that there is only one reference base per site.
#' A new column "base_sub_\code{base_type}" will be added to the result object.
#' 
#' Depending on your data and JACUSA2 command line options the following values are possible for 
#' \code{base_type}:
#' \itemize{
#' \item bases, 
#' \item arrest, or 
#' \item through
#' }
#' Additionally, if read/base stratification has been used additional columns with the suffix "_marked" will be
#' added.
#' 
#' @seealso TODO
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining the column to use as base counts. Default: bases.
#' @return result object with base subsitution ratio field "base_sub[_\code{base_type}]" added.
#' @examples
#' TODO
#' @export
add_base_sub_ratio <- function(result, base_type = "bases") {
  check_column_exists(result, base_type)
  
  result[[base_sub_ratio_col]] < base_sub_ratio(
    result[[REF_BASE_COLUMN]], 
    result[[base_type]]
  )
}

#' Retrieve base substitution ratio.
#' 
#' Retrieves ratio for base substitution stored under column "base_sub_\code{base_type}".
#' Use \code{add_base_sub_ratio()} to add this column, if it does not exist.
#' 
#' @seealso \code{add_base_sub_ratio()}
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining base counts that were used to define base substitution. Default: bases.
#' @return numeric vector of base substitutios ratios for \code{base_type} in \code{result}.
#' @examples 
#' data(rdd)
#' result <- add_base_sub_ratio(rdd)
#' str(get_sub_ratio(result))
#' @export
get_base_sub_ratio <- function(result, base_type = "bases") {
  check_column_exists(base_sub_ratio_col(base_type))
  result[[base_sub_ratio_col(base_type)]]
}

#' Calculates base substitution ratio (e.g.: editing frequency).
#' 
#' Calculates base substitution ratio (e.g.: editing frequency) for \code{ref_base} and base counts stored
#' in nx4 matrix \code{bases}.
#' \code{ref_base} must have only one reference base. A->G is okay, but AG->G is NOT allowed!
#' TODO what if more than 2 alleles, what does other_bc do
#'
#' @param ref_base vector of reference bases.
#' @param bases matrix of observed base call counts.
#' @param other_bc vector strings that represents observed base calls. Default: NULL, will be calculated from \code{bases}.
#' @return vector of base callsubstitution ratios.
#' @examples
#' ref_base <- c("A", "A", "T")
#' # Only one non-ref. base
#' bases <- matrix(c( 1,  0, 9, 0,
#'                    5,  0, 5, 0,
#'                    0, 10, 0, 0),
#'                 ncol = 4, byrow = TRUE)
#' # show base substiution ratios for observed base calls
#' base_sub_ratio(ref_base, bases)
#' 
#' # > one non-ref. base
#' bases <- matrix(c( 1,  2, 9, 1,
#'                    5,  3, 5, 1,
#'                    2, 10, 2, 1),
#'                 ncol = 4, byrow = TRUE)
#' # we are only interesected in A->G, T->C
#' other_bc <- c("G", "G", "C")
#' # show base substiution ratios for A->G, T->C
#' base_sub_ratio(ref_base, bases, observed_bc)
#' @export
base_sub_ratio <- function(ref_base, bases, other_bc = NULL) {
  colnames(bases) <- BASES
  
  observed_bc <- other_bc
  if (is.null(observed_bc)) {
    observed_bc <- apply(bases > 0, 1, function(m) { 
      return(paste0(BASES[m], collapse = "")) 
    })
  }
  
  # calculates the variant base between ref_base and observed_bc
  variant_bc <- mapply(function(r, o) {
    # remove reference base - only the variant base should remain
    v <- gsub(r, "", o)
    if (nchar(v) == 0) {
      v <- r
    }
    if (nchar(v) >= 2) {
      stop("More than 2 alleles not supported! ref: ", r, " observed BCs; ", o)
    }
    
    return(v)
  }, ref_base, observed_bc, USE.NAMES = FALSE)
  
  # create variable to index 
  # rows(1:length(variant_bc) and 
  # cols(match(variant_bc, BASES))
  # simultaneously in a matrix
  i <- cbind(1:length(variant_bc), match(variant_bc, BASES))
  # ratio := #variant BC / sum(BC)
  base_sub_ratio <- as.matrix(bases)[i] / rowSums(bases)
  # provide nice defaut value if ratio not defined
  base_sub_ratio[is.na(base_sub_ratio) | ref_base == variant_bc] <- 0.0
  
  base_sub_ratio
}

#' Column name for base substitution ratio for \code{base_type}.
#' 
#' Column name for base substitution ratio for \code{base_type}. 
#' \code{base_type} will be used a suffix to create the column name:
#' "base_sub[_\code{base_type}]".
#' 
#' @param base_type string TODO
#' @return string the represents the column name for base substition ratio for \code{base_type}.
#' @export
base_sub_ratio_col <- function(base_type) {
  process_col(BASE_SUB_RATIO, base_type)  
}
