#' Redefine reference base with observed base calls.
#' 
#' There must be only one reference base. A->G is okay, but AG->G is NOT allowed! 
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param ref_condition TODO
#' @param base_type TODO
#' @param keep_old string TODO Default: NULL
#' @return result object with base changes added.
#'
#' @export
redefine_ref_base <- function(result, ref_condition, base_type = "bases", keep_old = NULL) {
  if (! is.null(keep_old)) {
    result[[keep_old]] <- result[[REF_BASE_COLUMN]]
  }
  
  result <- group_by_site(result) %>% 
    dplyr::mutate(ref_base = extract_ref_base(condition, get_bc(., base_type))) %>%
    copy_attr(result, .)
  
  dplyr::ungroup(result)  
}

#' Extract reference base from observed base calls.
#' 
#' TODO
#' 
#' @param condition vector of numeric.
#' @param bc vector of string representing base calls.
#' @param ref_condition numeric representing the condition to use to define reference base.
#' @return vector of reference base(s) defined by \code{ref_condition} from \code{bc}.
#' @examples
#' TODO
#' @export
extract_ref_base <- function(condition, bc, ref_condition) {
  # use specific condition to derive reference base
  # for condition == ref_condition all bc should be nchar() == 1 and be identical
  if (length(ref_condition) != 1 | ! ref_condition %in% condition) {
    stop("Unknown ref_condition: ", ref_condition)
  }
  
  ref_base <- bc
  ref_base_i <- condition == ref_condition
  tmp_ref_base <- ref_base[ref_base_i] %>% unique() %>% sort() %>% paste0()
  ref_base[! ref_base_i] <- tmp_ref_base
  ref_base[ref_base_i] <- tmp_ref_base
  
  ref_base
}
