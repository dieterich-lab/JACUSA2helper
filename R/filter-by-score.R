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
#' @examples
#' data(HIVRT)
#' str(filter_by_min_score(HIVRT, min_score = 2, column = "pvalue"))
#' @export 
filter_by_min_score <- function(result, min_score, column = "score") {
  filter_by(result, !!rlang::sym(column) >= min_score)
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
#' @examples
#' data(HIVRT)
#' str(filter_by_max_score(HIVRT, max_score = 0.05, column = "pvalue"))
#' @export 
filter_by_max_score <- function(result, max_score, column = "score") {
  filter_by(result, !!rlang::sym(column) <= max_score)
}
