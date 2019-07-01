#' Write vector of values as bedGraph file
#'
#' \code{write_bedGraph()} Writes a bedGraph conform file with coordinates
#' defined by vectors: "contig", "start", and "end". According to:
#' https://genome.ucsc.edu/goldenPath/help/bedgraph.html
#' "start" and "end" are zero index and half opened. The caller needs to make sure 
#' that this is fullfilled.
#'
#' @param file String represents the filename of the BED graph file.
#' @param contig Vector of character vectors
#' @param start Vector of numericals zero indexed (>= 0)
#' @param end Vector of numericals half opened: [start, end)
#' @param value Vector of characters or numericals the reference value(s)
#'
#' @export
write_bedGraph <- function(file, contig, start, end, value) {
  # make sure start >= 0 - adhere to bedGraph file format
  if (any(start < 0)) {
    stop("Invalid data: some start > end")
  }
  # data frame to be written to file
  d <- data.frame(
    contig = contig, 
    start = start, end = end, 
    value = value, 
    stringsAsFactors = FALSE)
  write.table(d, file, 
              quote = FALSE, 
              sep = "\t", 
              row.names = FALSE, col.names = FALSE
  )
}

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
      .LRT_ARREST_COLUMN,
      .LRT_THROUGH_COLUMN,
      .LRT_ARREST_POS_COLUMN
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
