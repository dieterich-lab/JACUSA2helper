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
  write.table(d, file, quote = FALSE, sep = "\t", row.names = FALSE, col.names = FALSE)
}

#' Write a JACUSA list object to a file
#'
#' \code{write_result} Stores a list of sites in a file.
#' 
#' @param jacusa List created by \code{read_jacusa()}.
#' @param file String is the filename to store the list.
#' @param extra Vector of strings that define additional elements from the list that 
#'        will be stored in the file. 
#'
#' @export 
write_result <- function(jacusa, file, extra = NULL) {
  bed6 <- names(jacusa)[names(jacusa) %in% c("contig", "start", "end", "name", "stat", "pvalue", "strand")]
  
  data_fields <- c()
  data_type <- 0
  
  # add bases fields
  i <- grep("^bases", names(jacusa))
  base_fields <- names(jacusa)[i]
  if (length(base_fields > 0)) {
    data_fields <- c(data_fields, base_fields)
    data_type <- data_type + 1
  }
  
  # add ref2bc fields
  i <- grep("^ref2bc", names(jacusa))
  ref2bc_fields <- names(jacusa)[i]
  if (length(ref2bc_fields > 0)) {
    data_fields <- c(data_fields, ref2bc_fields)
    data_type <- data_type + 1
  }
  
  # add read arrest through fields
  i <- grep("arrest_bases|through_bases", names(jacusa))
  reads_fields <- names(jacusa)[i]
  if (length(reads_fields > 0)) {
    data_fields <- c(data_fields, reads_fields)
    data_type <- data_type + 1
  }
  
  # rearrange data fields
  if (data_type == 2) {
    tmp <- vector("character", length(data_fields))
    n <- length(data_fields)
    h <-  n / 2
    tmp[seq(1, n, 2)] <- data_fields[1:h]
    tmp[seq(2, n, 2)] <- data_fields[(h+1):n]
    data_fields <- tmp
  }
  
  info <- names(jacusa)[names(jacusa) %in% c("info", "filter_info", "refBase")]
  
  fields <- c(bed6, data_fields, info)
  if (! is.null(extra)) {
    fields <- c(fields, extra)
  }
  
  jacusa <- jacusa[fields]
  
  d <- as.data.frame(jacusa, stringsAsFactors = FALSE, check.names = FALSE)
  colnames(d)[1] <- paste0("#", colnames(d)[1])
  utils::write.table(d, file, col.names = TRUE, row.names = FALSE, quote = FALSE, sep = "\t")
}

# TODO JACUSA2.x specific write methods
.write_call_result <- function(jacusa, file, extra = NULL) {
  # TODO
}
# FIXME
.write_pileup_result <- function(jacusa, file, extra = NULL) {
  # TODO
}
# FIXME
.write_lrt_arrest_result <- function(jacusa, file, extra = NULL) {
  # TODO
}
# FIXME
.write_rt_arrest_result <- function(jacusa, file, extra = NULL) {
  # TODO
}