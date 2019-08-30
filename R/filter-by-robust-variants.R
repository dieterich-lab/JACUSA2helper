#' Retains sites that contain a variant base in all replicates in at least one condition.
#'
#' Enforces that at least one condition contains the variant base in all replicates. 
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @return result object with sites where at least one condition contains the variant base in all replicates.
#' 
#' @export 
filter_by_robust_variants <- function(result) {
  # check only two alleles per site
  #if (! check_max_alleles(result, 2)) {
  #  stop("Data contains sites with > 2 alleles. Please remove those sites.")
  #}

  result <- group_by_site(result, "meta_condition") %>%
    dplyr::filter(
      robust_variants_helper(primary, base_type, condition, bc_A, bc_C, bc_G, bc_T)
    ) %>% 
    copy_jacusa_attributes(result, .)

  dplyr::ungroup(result)
}

#' @noRd
robust_variants_helper <- function(primary, base_type, condition, bc_A, bc_C, bc_G, bc_T) {
  i <- primary & base_type == "total"
  condition <- condition[i]
  bc_A <- bc_A[i]
  bc_C <- bc_C[i]
  bc_G <- bc_G[i]
  bc_T <- bc_T[i]
  mat <- matrix(c(bc_A, bc_C, bc_G, bc_T), ncol = 4, byrow = FALSE)

  get_robust(condition, mat)
}
