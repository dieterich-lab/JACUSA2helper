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
#' @param cores number of cores to use
#' @return structure column with coverages
#' 
#' @export
coverage <- function(bases, cores = 1) {
  lapply_repl(bases, rowSums, cores)
}

#' Extract values from a structured column.
#' 
#' Extract values from a structured column.
#' 
#' @param id vector that unique identifies each row
#' @param x structured column
#' @param meta_cond vector of meta conditions
#' @return extracted column
#' 
#' @export
gather_repl <- function(id, x, meta_cond = NULL) {
  r <- list()
  for (cond in names(x)) {
    for (repl in names(x[[cond]])) {
      df <- tidyr::tibble(id = id, value = x[[cond]][[repl]])
      if (! is.null(meta_cond)) {
        df[["meta_cond"]] <- meta_cond
      }
      df[["cond"]] <- cond
      df[["repl"]] <- repl
      r[[length(r) + 1]] <- df
    }
  }
  dplyr::bind_rows(r)
}


#' Expand tagged reads
#' 
#' TODO
#' 
#' @param result object created by \code{read_result()} or \code{read_results()}.
#' @param cores Integer defines how many cores to use.
#' @param result object tagged and not tagged structured base columns.
#' @export
expand_tag <- function(result, cores = 1) {
  # extract data from tagged and not tagged reads
  total <- result %>% dplyr::filter(tag == .EMPTY)
  # set dummy column - not all sites have tagged reads
  total$tagged_bases <- lapply_repl(total$bases, function(x) { x - x})
  
  # extract data from tagged
  tagged <- result %>% dplyr::filter(tag != .EMPTY)
  matching <- match(tagged$coord, total$coord)
  
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
    total$tagged_bases,
    cores = cores
  )
  
  total
}
