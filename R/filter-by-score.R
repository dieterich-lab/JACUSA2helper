#' @noRd
get_score <- function(primary, base_type, score) {
  score[primary & base_type == "total"]
}

#' Restain sites with minimal score.
#'
#' \code{filter_by_score} removes sites that have score >= min_score.
#' 
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}.
#' @param min_score Numeric value that represents the minimal score.
#' @param field character vector that identifies the column
#' @return JACUSA2 result object with sites with score >= min_score
#' 
#' @export 
filter_by_min_score <- function(result, min_score, field = "score") {
  result <- result %>% 
    group_by_site("meta_condition") %>%
    filter(get_score(primary, base_type, !!field) >= min_score)

	result
}

#' Restain sites with maximal score.
#'
#' \code{filter_by_score} removes sites that have score <= min_score.
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()}.
#' @param max_score Numeric value that represents the maximal score.
#' @param field character vector that identifies the column
#' @return JACUSA2 result object with sites with score <= max_score.
#' 
#' @export 
filter_by_max_score <- function(result, max_score, field = "score") {
  result <- result %>% 
    group_by_site("meta_condition") %>%
    filter(get_score(primary, base_type, !!field) <= max_score)
  
  result
}
