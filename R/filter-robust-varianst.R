#' Retains sites that contain the variant base in all replicates in at least one condition.
#'
#' Enforces that at least one condition contains the variant base in all replicates. 
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}.
#' @return Returns JACUSA2 result object with sites where at least one condition contains the variant base in all replicates.  
#' 
#' @export 
filter_by_robust_variants <- function(result) {
  # TODO get conditions
  conditions <- result$condition %>% unique() %>% length()
  # check only two conditions
  if (conditions != 2) {
    stop("Only 2 conditions are supported!")
  }

    # check only two alleles per site
  if (! check_max_alleles(result, max_alleles = 2)) {
    stop("Data contains sites with >2 alleles. Please remove those sites.")
  }

  filter_robust_variants <- function(primary, base_type, condition, bc_A, bc_C, bc_G, bc_T) {
    i <- primary & base_type == "total"
    get_robust_variants(condition[i], bc_A[i], bc_C[i], bc_G[i], bc_T[i])
  }

  result <- result %>% 
    group_by_site("meta_condition") %>%
    dplyr::filter(
      filter_robust_variants(primary, base_type, condition, bc_A, bc_C, bc_G, bc_T)
    )

  dplyr::ungroup(result)
}

# helper function
#' @noRd
get_robust_variants <- function(condition, bc_A, bc_C, bc_G, bc_T) {
  # combine individual base call vectors
  mat <- matrix(c(bc_A, bc_C, bc_G, bc_T), ncol = 4, byrow = FALSE)
  
  mask <- get_mask(mat, op = "any")
  mask1 <- get_mask(mat[condition == 1, , drop = FALSE], op = "all")
  mask2 <- get_mask(mat[condition != 1, , drop = FALSE], op = "all")
  
  robust <- (mask1 | mask2) == mask
  
  all(robust)
}

# apply boolean operator "&","|" on all columns 
#' @noRd
get_mask <- function(mat, op) {
  mat <- t(apply(mat, 1, function(x) { x > 0 }))
  if (op == "all") {
    mat <- t(apply(mat, 2, all))
  } else if (op == "any") {
    mat <- t(apply(mat, 2, any))
  } else {
    stop("Unknown op: ", op)
  }
  
  mat
}
