# supports 1 or 2 conditions
# tests if all values that have been observed (>0) in all conditions (op = |)
# can observed in one of the conditions (op = &)
#' @noRd
get_robust <- function(condition, mat) {
  mask <- get_mask(mat, any)
  i <- as.vector(mask)

  conditions <- length(unique(condition))
  robust <- get_mask(mat[condition == 1, , drop = FALSE], op = all)
  if (conditions == 1) {
    return(any(robust[i] == mask[i]))
  }

  if(conditions == 2) {
    robust <- robust | get_mask(mat[condition != 1, ,drop = FALSE], op = all)
    return(all(robust[i] == mask[i]))
  }

  stop("Number of conditions must be 1 or 2 but not: ", length(conditions))
}

# helper: apply boolean operator "&"(all),"|"(any) on all columns 
#' @noRd
get_mask <- function(mat, op) {
  mat <- t(apply(mat, 1, function(x) { x > 0 }))
  if (identical(op, all) || identical(op, any)) {
    mat <- t(apply(mat, 2, op))
  } else {
    stop("Unknown op: ", op)
  }

  mat
}
