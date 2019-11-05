#' Redefine reference base with observed base calls.
#' 
#' There must be only one reference base. A->G is okay, but AG->G is NOT allowed! 
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param ref_cond numeric specifying the condition to define ref.
#' @param base_type string defining the column to use as base counts. Default: bases.
#' @param keep_old string specifying column to store old ref. Default: NULL.
#' @return result object with base changes added.
#'
#' @export
redefine_ref <- function(result, ref_cond, base_type = "bases", keep_old = NULL) {
  if (! is.null(keep_old)) {
    result[[keep_old]] <- result[[REF_BASE_COLUMN]]
  }
  
  result <- group_by_site(result) %>% 
    dplyr::mutate(
      !!rlang::sym(REF_BASE_COLUMN):=extract_ref(!!rlang::sym(CONDITION_COLUMN), get_bc(., base_type))
    ) %>%
    copy_attr(result, .)
  
  dplyr::ungroup(result)  
}

#' Extract reference base from observed base calls.
#' 
#' TODO
#' 
#' @param cond vector of numeric.
#' @param bc vector of string representing base calls.
#' @param ref_cond numeric representing the condition to use to define reference base.
#' @return vector of reference base(s) defined by \code{ref_cond} from \code{bc}.
#' @examples
#' cond <- c(1, 1, 2, 2)
#' bc <- c("A", "A", "AG", "AG")
#' extract_ref(cond, bc, 1)
#' @export
extract_ref <- function(cond, bc, ref_cond) {
  # use specific condition to derive reference base
  # for condition == ref_condition all bc should be nchar() == 1 and be identical
  if (length(ref_cond) != 1 | ! ref_cond %in% cond) {
    stop("Unknown ref_condition: ", ref_cond)
  }
  
  ref <- bc
  ref_i <- cond == ref_cond
  tmp_ref <- ref[ref_i] %>% unique() %>% sort() %>% paste0()
  ref[! ref_i] <- tmp_ref
  ref[ref_i] <- tmp_ref
  
  ref
}
