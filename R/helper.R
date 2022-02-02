# convenience: All possible bases
.BASES <- c("A", "C", "G", "T")
.EMPTY <- "*"
# convenience: DNA "->" RNA 
.SUB_SEP <- "->"
# no change between DNA and RNA: "A -> A" transformed to "no change"
.SUB_NO_CHANGE <- "no change"
# when interested only in specific base change, e.g.: A->G, the remaining are termed:
.SUB_OTHER <- "other"

# Helpers defining supported types by JACUSA2.x
.UNKNOWN_METHOD <- "unknown"
# call and pileup cannot be distinguished by output
.CALL_PILEUP <- "call-pileup"
.RT_ARREST <- "rt-arrest"
.LRT_ARREST <- "lrt-arrest"

.ATTR_TYPE <- "JACUSA2.type"
.ATTR_HEADER <-"JACUSA2.header"
.ATTR_COND_DESC <- "JACUSA2.cond_desc"


# convenience: description data fields
.CALL_PILEUP_COL <- "bases"

.ARREST_COL <- "arrest"
.THROUGH_COL <- "through"

.LRT_ARREST_POS_COL <- "arrest_pos"

# convenience: description info fields
.INFO_COL <- "info"
.FILTER_INFO_COL <- "filter"
.REF_BASE_COL <- "ref"

# JACUSA2 CLI option -B
.SUB_TAG_COL <- "tag"

.ARREST_RATE_COL <- "arrest_rate"
.META_COND_COL <- "meta_cond"

.COV <- "cov"

#' Calculate coverage for structured column.
#' 
#' Calculate coverage for structured column.
#' 
#' @param bases structured column of bases
#' @return structure column with coverages
#' 
#' @export
coverage <- function(bases) {
  lapply_repl(bases, rowSums)
}

#' Extract values from a structured column.
#' 
#' Extract valeus from a structured column and adds "contig:start-end:strand".
#' This is usefull if data should be used with `ggplot2`.
#' 
#' @param result JACUSA2 result object
#' @param col name of structured column
#' @return extracted column
#' 
#' @export
gather_repl <- function(result, col) {
  r <- list()
  
  #if (! is.null(meta_cond)) {
  #  df[["meta_cond"]] <- meta_cond
  #}
  
  df <- GenomicRanges::mcols(result)[[col]]
  id_ <- JACUSA2helper::id(result)
  for (cond in names(df)) {
    for (repl in names(df[[cond]])) {
      tmp <- tidyr::tibble(value = df[[cond]][[repl]])
      tmp[["cond"]] <- cond
      tmp[["repl"]] <- repl
      tmp[["id"]] <- id_
      r[[length(r) + 1]] <- tmp
    }
  }
  dplyr::bind_rows(r)
}


#' Expand tagged reads
#' 
#' This will expand tagged reads and create new column called "not_untagged_reads".
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @export
expand_tag <- function(result) {
  result$id <- id(result)
  # extract data from tagged and not tagged reads
  tag <- NULL
  total <- result %>% dplyr::filter(tag == .EMPTY)
  # set dummy column - not all sites have tagged reads
  total$tagged_bases <- lapply_repl(total$bases, function(x) { x - x})
  
  # extract data from tagged
  tagged <- result %>% dplyr::filter(tag != .EMPTY)
  matching <- match(tagged$id, total$id)
  
  if (any(! is.na(matching))) {
    tagged_bases <- tagged$bases[which(! is.na(matching)), ]
    total$tagged_bases[matching[! is.na(matching)], ] <- tagged_bases
  }
  # untagged = total - tagged
  total$not_tagged_bases <- mapply_repl(
    function(total, tagged) {
      total - tagged
    }, 
    total$bases,
    total$tagged_bases
  )
  
  total
}

#' Extend region
#' 
#' Extend region
#' 
#' @param gr object created by \code{read_result()} or \code{read_results()}.
#' @param left integer number of nucleotides to shift.
#' @param right integer number of nucleotides to shift.
#' @return Extended region
#' @export
extend <- function(gr, left = 0, right = 0) {
  GenomicRanges::GRanges(
    seqnames=GenomicRanges::seqnames(gr),
    ranges=IRanges::IRanges(
      start=GenomicRanges::start(gr) - left,
      end=GenomicRanges::end(gr) + right
    ),
    strand=GenomicRanges::strand(gr)
  )
}
