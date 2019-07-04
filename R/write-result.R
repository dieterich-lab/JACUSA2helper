# FIXME
# Write a JACUSA2 result object to a file
#
# \code{write_result()} Stores a JACUSA2 result object to a file. 
# TODO what happens to additional data added?
# 
# @param result object created by \code{read_jacusa()}.
# @param file String is the filename to store the JACUSA2 object.
#
# @export 
write_result <- function(result, file) {
  stop("This is not implemented yet!")
  bed6 <- c(
    "contig", "start", "end", 
    "name", 
    "score", 
    "strand"
  )

  # pack
  # warning: unknown fields
  # convenience: description info fields
  
  data_fields <- c()
  if (result$type == .CALL_PILEUP_METHOD_TYPE) {
    data_fields <- c(data_fields, .CALL_PILEUP_COLUMN)
  } else if (result$type == .RT_ARREST_METHOD_TYPE) {
    data_fields <- c(
      data_fields, 
      .RT_ARREST_COLUMN, 
      .RT_THROUGH_COLUMN
    )
  } else if (result$type == .LRT_ARREST_METHOD_TYPE) {
    data_fields <- c(
      data_fields, 
      LRT_ARREST_COLUMN,
      LRT_THROUGH_COLUMN,
      LRT_ARREST_POS_COLUMN
    )
  } else {
    stop("Unknown method type: ", unique(result_type))
  }
  info <- c(.INFO_COLUMN, .FILTER_INFO_COLUMN, .REF_BASE_COLUMN)
  
  fields <- c(bed6, data_fields, info)
  extra <- NULL # TODO
  
  # select known fields
  result <- result[, fields]
  # explode

  df <- as.data.frame(result, stringsAsFactors = FALSE, check.names = FALSE)
  colnames(df)[1] <- paste0("#", colnames(dt)[1])
  utils::write.table(df, file, 
                     col.names = TRUE, row.names = FALSE, 
                     quote = FALSE, sep = "\t")
}

#' TODO
#' @importFrom magrittr %>%
#' 
#' @noRd
write_results <- function(results, files) {
  # TODO
}
