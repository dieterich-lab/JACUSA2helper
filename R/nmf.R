#' Create data matrix for NMF
#' 
#' Create data matrix from JACUSA2 output object for non-negative matrix factorization.
#' 
#' TODO add genome - preserve correct coordinates
#' 
#' 
#' @param result JACUSA2 result object.
#' @param scores Vector of strings. Columns in JACUSA2 result object to use as scores.
#'               Default: "score", "insertion_score", "deletion_score"
#' @param context numeric context around a site. Aggregate scores TODO
#' @param rename_score TODODefault: "call2_score"
#' @param meta_cond boolean - split features based on meta conditions
#' @return Data frame
#' 
#' @importFrom GenomicRanges GRanges start mcols
#' @importFrom IRanges findOverlaps 
#' @importFrom S4Vectors queryHits subjectHits
#' @export
create_data <- function(result, scores = c("score", "deletion_score", "insertion_score"), context = 2, rename_score = "call2_score", meta_cond = TRUE) {
  names_from <- "position"
  names_glue <- "{.value}_{position}"
  cols <- scores
  if ("meta_cond" %in% colnames(mcols(result)) && meta_cond) {
    names_from <- c("meta_cond", "position")
    names_glue <- paste0("{meta_cond}_", names_glue)
    cols <- c("meta_cond", cols)
  }

  gr_scores <- result[, cols]
  if (!is.null(rename_score) && "score" %in% colnames(mcols(gr_scores))) {
    colnames(mcols(gr_scores))[colnames(mcols(gr_scores)) == "score"] <- rename_score
    scores[scores == "score"] <- rename_score
  }

  extended <- extend(gr_scores, left = context, right = context)
  unique_extended <- unique(extended)
  
  hits <- findOverlaps(gr_scores, unique_extended)
  ov_gr_scores <- gr_scores[queryHits(hits)]
  ov_unique_extended <- unique_extended[subjectHits(hits)]

  # coordinates of overlapping region: contig:start-end:strand
  ov_gr_scores$region <- as.character(ov_unique_extended)
  
  # add site position within extended region TODO/FIXME strand
  ov_gr_scores$position <- start(ov_gr_scores) - start(ov_unique_extended) + 1

  ov_gr_scores %>% 
    as.data.frame() %>%
    tidyr::pivot_wider(
      id_cols = "region", 
      names_from = names_from, 
      values_from = scores, 
      names_glue = names_glue,
      names_sort = TRUE,
      values_fill = NA
    )
}



#' Learn pattern from JACUSA2 output
#' 
#' @param mods TODO 
#' @return TODO
#' 
learn_nmf <- function(data, mods) {
  # TODO
}

#' Predict modifications in JACUSA2 output
#' 
#' @param nmf TODO
#'
predict_mods <- function(nmf = NULL) {
  if (is.null(nmf)) {
    # TODO get learned NMF
  }
  # TODO
}