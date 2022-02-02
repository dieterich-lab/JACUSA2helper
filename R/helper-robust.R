#' Check if data is robust
#' 
#' Tests if all values that have been observed (>0) in all conditions (op = |)
#  can observed in one of the conditions (op = &)
#' Supports 1 or 2 conditions.
#' 
#' @param x tibble of numeric.
#' @return logical vector indicating robust rows.
#' @export
robust <- function(x) {
  not_null <- lapply_repl(x, function(x) {x > 0})

  mask_any <- .mask_any(not_null)
  mask_all <- .mask_all(not_null)
  
  mask <- mask_any & mask_all | ! mask_any
  n <- dim(mask)[2]

  rowSums(mask) == n
}

#' @noRd
.mask_any <- function(x) {
  lapply_cond(x, function(cond) { 
    Any(cond)
  }) %>% Any() %>% tidyr::as_tibble()
}

#' @noRd
.mask_all <- function(x) {
  lapply_cond(x, function(cond) { 
    All(cond)
  }) %>% Any() %>% tidyr::as_tibble()
}


#' Apply f to all conditions
#' 
#' Wrapper for lapply
#' @param x tibble of data per condition
#' @param f function to apply to each condition data
#' @param ... parameters for f
#' @return tibble
#' @export
lapply_cond <- function(x, f, ...) {
  lapply(x, f, ...) %>% .as() %>% tidyr::as_tibble()
}

#' Apply f to all replicates
#' 
#' Wrapper for lapply
#' @param x tibble of data per condition
#' @param f function to apply to each replicate data
#' @param ... parameters for f
#' @return tibble
#' @export
lapply_repl <- function(x, f, ...) {
  .helper <- function(y) {
    lapply(y, f, ...) %>% 
      lapply(.as) %>% 
      tidyr::as_tibble()
  }

  lapply(x, .helper) %>% tidyr::as_tibble()
}

# make everything a tibble if it has a 2nd dimension
#' @noRd
.as <- function(y) {
  if (is.vector(y)) {
    return(y)
  }
  return(tidyr::as_tibble(y))
}

#' Apply f to all replicates
#' 
#' Wrapper for mapply.
#' @param f function to apply to each replicate data
#' @param ... see mapply
#' @param MoreArgs see mapply
#' @return tibble
#' @export
mapply_repl <- function(f, ..., MoreArgs = NULL) {
  .helper <- function(...) {
    dots <- list(...)
    mapply(f, ..., MoreArgs = MoreArgs, SIMPLIFY = FALSE) %>% 
      lapply(.as) %>% 
      tidyr::as_tibble()
  }
  
  mapply(.helper, ..., SIMPLIFY = FALSE) %>% tidyr::as_tibble()
}
