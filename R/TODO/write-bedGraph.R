#' Writes vector of values as bedGraph file.
#'
#' Writes a bedGraph conform file with coordinates
#' defined by vectors: "contig", "start", and "end". According to:
#' https://genome.ucsc.edu/goldenPath/help/bedgraph.html
#' "start" and "end" are zero indexed and half opened. The caller needs to make sure 
#' that this is fullfilled.
#'
#' @param file String represents the filename of the BED graph file.
#' @param contig vector of character string represting the contig(s)
#' @param start vector of numericals zero indexed (>= 0)
#' @param end vector of numericals half opened: [start, end)
#' @param value vector of character strings or numericals representing value(s)
#'
#' @export
write_bedGraph <- function(file, contig, start, end, value) {
  # make sure start >= 0 - adhere to bedGraph file format
  if (any(start < 0)) {
    stop("Invalid data: some start < 0")
  }
  # data frame to be written to file
  d <- data.frame(
    contig = contig, 
    start = start, end = end, 
    value = value, 
    stringsAsFactors = FALSE
  )
  utils::write.table(d, file, 
              quote = FALSE, 
              sep = "\t", 
              row.names = FALSE, col.names = FALSE
  )
}
