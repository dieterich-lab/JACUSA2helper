#' Create data matrix for NMF
#' 
#' Create data matrix from JACUSA2 output object for non-negative matrix factorization.
#' 
#' @seealso GenomicRanges::seqlengths how to set sequence information on GRanges object to preserve correct ranges.
#' 
#' @param result JACUSA2 result object.
#' @param scores Vector of strings. Columns in JACUSA2 result object to use as scores.
#'               Default: "score", "insertion_score", "deletion_score"
#' @param ref_context reference context of a potential site. Default: "A".
#' @param context number of nucleotides to consider around a potential site. Default: 2.
#' @param rename_score Rename column "score". Default: "call2_score".
#' @param meta_cond logical - split features based on meta conditions
#' @return Data frame
#' 
#' @importFrom GenomicRanges GRanges start mcols strand
#' @importFrom IRanges findOverlaps countOverlaps
#' @importFrom S4Vectors queryHits subjectHits
#' @importFrom tidyr all_of
#' @export
create_data <- function(result, scores = c("score", "deletion_score", "insertion_score"), ref_context = "A", context = 2, rename_score = "call2_score", meta_cond = TRUE) {
  names_from <- "position"
  names_glue <- "{.value}_{position}"
  cols <- scores
  meta_conds <- NULL
  if ("meta_cond" %in% colnames(mcols(result)) && meta_cond) {
    names_from <- c("meta_cond", "position")
    names_glue <- paste0("{meta_cond}_", names_glue)
    cols <- c("meta_cond", cols)
    meta_conds <- unique(result$meta_cond)
  }
  cols <- c(cols, "ref", "filter")

  gr_scores <- result[, cols]

  if (!is.null(rename_score) && "score" %in% colnames(mcols(gr_scores))) {
    colnames(mcols(gr_scores))[colnames(mcols(gr_scores)) == "score"] <- rename_score
    scores[scores == "score"] <- rename_score
  }

  site <- gr_scores[gr_scores$ref == ref_context]
  if ("filter" %in% colnames(mcols(site))) {
    site <- site[!grepl("Y", mcols(site)$filter, fixed = TRUE)]
  }
  site <- unique(site)
  
  extended <- extend(site, left = context, right = context)
  hits <- findOverlaps(gr_scores, extended)
  ov_gr_scores <- gr_scores[queryHits(hits)]
  ov_extended <- extended[subjectHits(hits)]

  # coordinates of overlapping region: contig:start-end:strand
  ov_gr_scores$region <- as.character(ov_extended)

  # add site position within extended region
  ov_gr_scores$position <- ifelse(
    strand(ov_gr_scores) == "+", 
    start(ov_gr_scores) - start(ov_extended) + 1, 
    end(ov_extended) - end(ov_gr_scores) + 1
  )
  mcols(ov_gr_scores)[, "ref"] <- NULL

  data_matrix <- mcols(ov_gr_scores) %>% 
    as.data.frame() %>%
    tidyr::pivot_wider(
      id_cols = region, 
      names_from = all_of(names_from), 
      values_from = all_of(scores), 
      names_glue = names_glue,
      names_sort = TRUE,
      values_fill = NA
    ) %>% 
    as.data.frame()

  rownames(data_matrix) <- data_matrix$region
  data_matrix$region <- NULL

  reorder_cols <- c()
  for (meta_cond in meta_conds) {
    for (score in scores) {
      reorder_cols <- c(reorder_cols,  paste(meta_cond, score, 1:(1 + 2 * context), sep = "_"))
    }
  }

  data_matrix[, reorder_cols]
}


#' Estimate factorization rank from JACUSA2 output
#' 
#' Given a data matrix created by `create_data()` this function performs non-negative matrix factorization.
#' 
#' @param x target data to fit, i.e. a matrix-like object - use `create_features()`
#' @param nmf_args argument to be forward to `NMF::nmf`. @seealso NMF::nmf
#' @param nmf_seed Default: "nndsvd". @seealso NMF::nmfSeed
#' @return Depends on `evaluate`: FALSE @seealso NMF::nmf, TRUE a list of objects.
#' 
#' @importFrom NMF randomize
#' @export
learn_nmf <- function(x, nmf_args = NULL, nmf_seed = "nndsvd") {
  NMF::nmfSeed(nmf_seed)
  if (is.null(nmf_args)) {
    nmf_args <- list(rank = 2:10, nrun = 10, seed = 123456, .opt = "vp3")
  }

  # learn model and null model
  estim_r <- do.call(NMF::nmf, c(list(x = x), nmf_args)) 
  
  # how can we select factorization rank ?
  chosen_rank <- min(
    nmf_args$rank[which.max(estim_r$measures$silhouette.consensus)],
    nmf_args$rank[which.max(estim_r$measures$cophenetic)]
  )
  # apply estimated factorization rank 
  nmf_args[["rank"]] <- chosen_rank
  nmf_matrix <- do.call(NMF::nmf, c(list(x = x), nmf_args))
  
  w <- NMF::basis(nmf_matrix)
  chosen_pattern <- as.vector(which.max(table(apply(w, 1, function(x) { which(x == max(x)) } ))))

  return(
    list(
      estim_r = estim_r,
      chosen_rank = chosen_rank,
      chosen_pattern = chosen_pattern,
      nmf_matrix = nmf_matrix
    )
  )

  nmf_matrix
}


#' Predict modifications in JACUSA2 output
#' 
#' Use data matrix and an matrix factorization to predict modification sites.
#' 
#' @param x target data to fit, i.e. a matrix-like object - use `create_data()`.
#' @param nmf_results Default: data(m6a_nmf_results).
#' @return Score matrix.
#'
#' @importFrom NMF coef
#' @export
predict_mods <- function(x, nmf_results = NULL, ) {
  if (is.null(nmf_results)) {
    data(m6a_nmf_results)
    nmf_results <- m6a_nmf_results
    rm(m6a_nmf_results)
  }
  h <- coef(nmf_results$nmf_matrix)
  
  stopifnot(ncol(x) == ncol(h))
  # TODO stopifnot(ncol(x) == length(intersect(colnames(x), colnames(h))))

  x <- as.matrix(x)
  scores <- x %*% t(h)
  score <- scores[, nmf_results$chosen_pattern]
  
  scores <- as.data.frame(scores)
  colnames(scores) <- paste0("NMF", 1:ncol(scores))
  scores[["score"]] <- score

  scores
}

# TODO remove
fix_coords <- function(x) {
  x <- gsub("_", "-", x)
  x <- GRanges(x)
  start(x) <- start(x) + 1
  
  as.character(x)
}
