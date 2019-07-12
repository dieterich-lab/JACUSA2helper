#' Adds a summary of a column in a JACUSA2 result object. (EXPERIMENTAL)
#'
#' For an existing \code{column} in a JACUSA2 result object, a \code{summarise} function, and 
#' an \code{aggregate} cirteria ("site" or "condition"), a new summary column will be created.
#' 
#' The name of the new column is a combination of the following arguments:
#' \describe{
#'   \item{\code{aggregate}]}{"site" or "condition",}
#'   \item{\code{column}]}{the column name, and}
#'   \item{(\code{suffix})}{an optional suffix string.}
#' }
#' Each argument will be separated by: "_".
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param column character string specifing the column to use for the summary
#' @param aggregate character string defining how to aggregate: "site" or "condition".
#' @param summarise function to be used for \code{column} to generate summary.
#' @param suffix optional character string to add to the name of the new summary column.
#' @return result object with a new summary column added.
#' 
#' @export
add_summary <- function(result, column, aggregate, summarise, suffix = "") {
  check_column_exists(result, column)
  possible_values <- c("site", "condition")
  if (! aggregate %in% possible_values) {
    stop(
      "Unknown value for aggregate: ", aggregate, ". ",
      "Possible values: ", paste(possible_values, sep = ","))
  }

  # adjust group_by with user provided aggregate
  opt_site_vars <- OPT_SITE_VARS
  if (aggregate == "condition") {
    opt_site_vars <- c(opt_site_vars, aggregate())
  }

  # create name of new summary column
  new_variable <- paste(aggregate, column, sep = "_")
  if (nchar(suffix) > 0) {
    new_variable <- paste(new_variable, suffix, sep = "_")
  }

  summary_helper <- function(v) {
    summary <- summarise(v)
    stopifnot(length(summary) == 1)

    return(summary)
  }
  
  result <- group_by_site(
    result, 
    OPT_SITE_VARS, 
    primary, base_type
  ) %>%
    dplyr::mutate(!!rlang::sym(new_variable):=summary_helper(!!rlang::sym(column))) %>%
    copy_jacusa_attributes(result, .)

  dplyr::ungroup(result)
}
