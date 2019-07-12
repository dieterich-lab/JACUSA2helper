#' @noRd
get_score_helper <- function(primary, base_type, score) {
  score[primary & base_type == "total"]
}

#' Retains sites by minimal score.
#'
#' Retains sites that have score >= min_score.
#' 
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param min_score numeric value that specifies the minimal score.
#' @param column character string that specifies the column of the score.
#' @return result object with sites where score >= min_score.
#' 
#' @export 
filter_by_min_score <- function(result, min_score, column = "score") {
  result <- group_by_site(result, "meta_condition") %>%
    dplyr::filter(
      get_score_helper(primary, base_type, !!rlang::sym(column)) >= min_score
    ) %>%
    dplyr::ungroup() %>%
    copy_jacusa_attributes(result, .)

	result
}

#' Restains sites with maximal score.
#'
#' Retains sites that have score <= max_score.
#'
#' @importFrom magrittr %>%
#' @importFrom rlang syms
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param max_score numeric value that specifies the maximal score.
#' @param column character string that specifies the column of the score.
#' @return result object with sites where score <= max_score.
#' 
#' @export 
filter_by_max_score <- function(result, max_score, column = "score") {
  result <- group_by_site(result, "meta_condition") %>%
    dplyr::filter(
      get_score_helper(primary, base_type, !!rlang::sym(column)) <= max_score
    ) %>%
    dplyr::ungroup() %>%
    copy_jacusa_attributes(result, .)
  
  result
}
