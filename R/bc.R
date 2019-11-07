#' Add observed base calls.
#' 
#' Adds observed base calls calculated for base column specified by \code{base_type}.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining the column to use as base counts. Default: bases.
#' @return result object with observed base calls added.
#' @export
add_bc <- function(result, base_type = "bases") {
  check_column_exists(result, base_type)
  result[[bc_col(base_type)]] <- base_call(result[[base_type]])
  
  result  
}

#' Retrieve observed base calls for \code{base_type}.
#' 
#' Retrieves observed base calls for base counts stored under \code{base_type}.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining base counts. Default: bases.
#' @return string vector with observed base calls for \code{base_type}.
#' @examples
#' data(HIVRT)
#' # get all observed base calls per site
#' str(get_bc(HIVRT, "bases"))
#' # get only arrest base calls per site
#'  str(get_bc(HIVRT, "arrest"))
#' # get only through base calls per site
#'  str(get_bc(HIVRT, "through"))
#' @export
get_bc <- function(result, base_type = "bases") {
  result[[bc_col(base_type)]]
}

#' Calculate observed base calls for base counts.
#' 
#' Calculates observed base calls for base counts. 
#' \code{bases} is expected to be a nx4 matrix or data frame.
#' 
#' @param bases nx4 matrix or data frame of base call counts.
#' @return string vector of obseved base calls for \code{bases}.
#' @examples
#' bases <- tibble::tribble(
#'  ~A, ~C, ~G, ~T,
#'   1,  0,  0,  0,
#'   0,  1,  0,  0,
#'   0,  0,  1,  0,
#'   0,  0,  0,  1,
#'   1,  1,  1,  1,
#' )
#' str(base_call(bases))
#' @export
base_call <- function(bases) {
  bc <- tibble::as_tibble(
    matrix(
      rep(BASES, nrow(bases)),
      ncol = length(BASES),
      byrow = TRUE
    ),
    .name_repair = "minimal"
  )
  colnames(bc) <- BASES
  
  bc[bases == 0] <- ""
  l <- as.list(bc)
  
  do.call(stringr::str_c, c(l, sep = ""))
}

#' Calculate the most abundant non reference base call.
#' 
#' Calculates the most abundant non reference base call. 
#' \code{bases} is expected to be a nx4 matrix or data frame.
#' 
#' @param ref string vector reference bases.
#' @param bases nx4 matrix or data frame of base call counts or ratio.
#' @return string vector of most abundant non reference base call for \code{bases}.
#' @export
base_call_non_ref <- function(ref, bases) { 
  # set refere base to -1
  #browser()
  if (is.vector(bases)) {
    bases[ref] <- -1
    
    return(names(bases[which.max(bases)]))
  }
  
  bases[cbind(1:length(ref), match(ref, names(bases)))] <- -1

  names(bases)[max.col(bases)]
}

#' Column name for observed base calls for \code{base_type}.
#' 
#' Column name for observed base calls for \code{base_type}. 
#' \code{base_type} will be used to create the column name:
#' \code{bc[_base_type]}. Using \code{base_type = "bases"} 
#' will result in the field \code{bc}.
#' 
#' @param base_type string specifiying base column. Default: bases.
#' @return string that represents the column name for observed base calls for \code{base_type}.
#' @export
bc_col <- function(base_type = "bases") {
  process_col(BC, base_type)
}
