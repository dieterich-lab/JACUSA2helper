#' Retains sites that contain a variant base in all replicates in at least one condition.
#'
#' Enforces that at least one condition contains the variant base in all replicates. 
#'
#' @importFrom magrittr %>%
 #' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param base_type string defining the column to use as base counts. Default: bases.
#' @param ... passed to internal \code{group_by_site} statement. Add additional grouping variable here, e.g.: "meta_condition".
#' @return result object with sites where at least one condition contains the variant base in all replicates.
#' @examples
#' data(rdd)
#' str(filter_by_robust_variants(rdd))
#' @export 
filter_by_robust_variants <- function(result, base_type = "bases", ...) {
  result <- group_by_site(result, ...) %>%
    filter_by(
      robust(
        !!rlang::sym(CONDITION_COLUMN), 
        !!rlang::sym(base_type)
      )
    )

  dplyr::ungroup(result)
}
