#' Add observed base calls.
#' 
#' Adds observed base calls calculated from \code{base_type} column.
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining the column to use as base counts. Default: bases.
#' @return result object with observed base calls added.
#' @examples
#' data(rdd)
#' result <- add_bc_obs(result)
#' str(result[["bases"]])
#' 
#' # for rt-arrest
#' data(rdd)
#' # add observed base calls for arrest reads
#' result <- add_bc_obs(result, "arrest")
#' # add observed base calls for through reads
#' result <- add_bc_obs(result, "through")
#' # only print observed base calls for 
#' # arrest and through reads
#' cols <- paste0(c("arrest", "through"), "_bc_obs")
#' str(result[[cols]])
#' @export
add_bc_obs <- function(result, base_type = "bases") {
  check_column_exists(result, base_type)
  result[[bc_obs_col(base_type)]] <- bc_obs(result[[base_type]])
  
  result  
}

#' Retrieve observed base calls for \code{base_type}.
#' 
#' Retrieves observed base calls for base counts stored under "\code{base_type}".
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining base counts. Default: bases.
#' @return string vector with observed base calls for \code{base_type}.
#' @examples
#' TODO
#' @export
get_bc_obs <- function(result, base_type = "bases") {
  result[[bc_obs_col(base_type)]]
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
#' str(bc_obs(bases))
#' @export
bc_obs <- function(bases) {
  bc_obs <- tibble::as_tibble(
    matrix(
      rep(BASES, nrow(bases)),
      ncol = length(BASES),
      byrow = TRUE
    ),
    .name_repair = "minimal"
  )
  colnames(bc_obs) <- BASES
  
  bc_obs[! bases > 0] <- ""
  l <- as.list(bc_obs)
  
  do.call(stringr::str_c, c(l, sep = ""))
}

#' Column name for observed base calls for \code{base_type}.
#' 
#' Column name for observed base calls for \code{base_type}. 
#' \code{base_type} will be used a suffix to create the column name:
#' "bc_obs[_\code{base_type}]". Using \code{base_type = "bases"} 
#' will result in the field "bc_obs".
#' 
#' @param base_type string TODO
#' @return string the represents the column name for observed base calls for \code{base_type}.
#' @export
bc_obs_col <- function(base_type = "bases") {
  process_col(BC_OBS, base_type)
}
