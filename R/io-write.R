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
# Write a JACUSA2 object to a file
#
# \code{write_result()} Stores a JACUSA2 object to a file. 
# TODO what happens to additional data added?
# 
# @param jacusa2 object created by \code{read_jacusa()}.
# @param file String is the filename to store the JACUSA2 object.
#
# @export 
write_result <- function(jacusa2, file) {
  bed6 <- names(jacusa2)[names(jacusa) %in% c(
    "contig", "start", "end", 
    "name", 
    "score", 
    "strand")]
  
  data_fields <- c()
  if (jacusa2$type == .CALL_PILEUP_METHOD_TYPE) {
    data_fields <- .get
  } else {
    stop()    
  }
  data_fields <- .get_call_pileup_result(jacusa2)
  info <- names(jacusa)[names(jacusa) %in% c("info", "filter_info", "ref_Base")]
  
  fields <- c(bed6, data_fields, info)
  if (! is.null(extra)) {
    fields <- c(fields, extra)
  }
  
  jacusa2 <- jacusa2[fields]
  dt <- as.data.frame(jacusa2, stringsAsFactors = FALSE, check.names = FALSE)
  colnames(dt)[1] <- paste0("#", colnames(dt)[1])
  utils::write.table(dt, file, 
                     col.names = TRUE, row.names = FALSE, 
                     quote = FALSE, sep = "\t")
}
