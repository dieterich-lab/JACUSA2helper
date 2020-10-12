


#' Check if data is robust
#' 
#' Tests if all values that have been observed (>0) in all conditions (op = |)
#  can observed in one of the conditions (op = &)
#' Supports 1 or 2 conditions.
#' 
#' @param data tibble of numeric.
#' @return logical vector indicating robust rows.
#' @export
robust <- function(data) {
  not_null <- apply_repl(df, function(x) {x > 0})

  mask_any <- .mask_any(not_null)
  mask_all <- .mask_all(not_null)
  
  mask <- mask_any & mask_all | ! mask_any
  n <- length(names(mask))
  
  rowSums(mask) == n
}

#' @noRd
.mask_any <- function(df) {
  apply_cond(df, function(cond) { 
    Reduce("|", cond)
  }) %>% Reduce("|", .) %>% tidyr::as_tibble()
}

#' @noRd
.mask_all <- function(df) {
  apply_cond(df, function(cond) { 
    Reduce("&", cond)
  }) %>% Reduce("|", .) %>% tidyr::as_tibble()
}


#' Apply FUN to all tibbles of conditions
#' 
#' TODO
#' @param X TODO
#' @param FUN TODO
#' @param cores TODO
#' @param ... TODO
#' @export
apply_cond <- function(X, FUN, cores = 1, ...) {
  parallel::mclapply(
    X, FUN, ..., 
    mc.cores = min(names(X), cores), mc.preschedule = FALSE
  ) %>% lapply(., tidyr::as_tibble) %>% tidyr::as_tibble()
}

#' Apply FUN to all replicates
#' 
#' TODO
#' @param X TODO
#' @param FUN TODO
#' @param cores TODO
#' @param ... TODO
#' @export
apply_repl <- function(X, FUN, cores = 1, ...) {
  # lapply(., tidyr::as_tibble) %>% 
  parallel::mclapply(
    X, function(cond) {
      lapply(cond, FUN, ...) %>% tidyr::as_tibble()
    }, mc.cores = min(names(X), cores), mc.preschedule = FALSE
  ) %>% tidyr::as_tibble()
}
