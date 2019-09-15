#' Retains sites that contain an arrest event in all replicates in at least one condition.
#'
#' Enforces that at least one condition contains an arrest event in all replicates. 
#' The result object must be the output of the following JACUSA2 methods: 
#' rt-arrest or lrt-arrest.
#'
#' @importFrom magrittr %>%
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param min_diff numeric minimal difference of arrest rates (Default: NULL)
#' @return result object with sites where at least one condition contains the arrest event in all replicates.
#' 
#' @export 
filter_by_robust_arrest_events <- function(result, min_diff = NULL) {
  require_jacusa_method(result, c(RT_ARREST_METHOD_TYPE, LRT_ARREST_METHOD_TYPE))

  result <- group_by_site(result, "meta_condition") %>%
    dplyr::filter(
      robust_arrest_events_helper(primary, base_type, condition, replicate, coverage)
    ) %>%
    copy_jacusa_attributes(result, .)

  if (! is.null(min_diff)) {
    result <- group_by_site(result, "meta_condition") %>%
      dplyr::filter(
        get_difference_helper(primary, base_type, condition, arrest_rate) >= min_diff
      ) %>%
      copy_jacusa_attributes(result, .)
  }

  dplyr::ungroup(result)
}

#' @noRd
get_difference_helper <- function(
  primary, base_type, 
  condition, 
  arrest_rate) {

  i <- primary == TRUE & base_type == "total"

  mean1 <- mean(arrest_rate[i & condition == 1])
  mean2 <- mean(arrest_rate[i & condition == 2])

  abs(mean1 - mean2)
}

#' @noRd
robust_arrest_events_helper <- function(
  primary, base_type, 
  condition, replicate, 
  coverage) {

  i <- primary & base_type %in% c(ARREST_COLUMN, THROUGH_COLUMN)
  df <- data.frame(
    condition = condition[i], 
    replicate = replicate[i],
    base_type = base_type[i],
    coverage = coverage[i],
    stringsAsFactors = FALSE
  )
  df <- tidyr::spread(df, base_type, coverage, convert = TRUE)
  condition <- df$condition
  df <- df[, c(ARREST_COLUMN, THROUGH_COLUMN)]
  mat <- as.matrix(df)

  get_robust(condition, mat)
}
