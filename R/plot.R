#' Plot cumulative read coverage
#' 
#' TODO
#' 
#' @param result object create by \code{read_result()}
#' @return plot object
#'
#' @export
plot_ecdf_coverage <- function(result) {
  if (is.null(result[["coverage"]])) {
    result <- add_coverage(result)
  }

  plot_ecdf_column(result, "coverage") +
    ggplot2::xlab("Read coverage")
}

#' Plot TODO
#' 
#' TODO
#' 
#' @param result object \code{read_results()}
#' @param column to be used for plotting
#' @return Plot TODO
#'
#' @export
plot_ecdf_column <- function(result, column) {
  conditions <- length(unique(result$condition))
  replicates <- length(unique(result$replicate))
  
  if (is.null(result[[.DATA_DESC]])) {
    result <- add_data_desc(paste0("Cond.", 1:conditions))
    # result[[.DATA_DESC]] <- paste0("Cond. ", result$condition, "  Rep. ", result$replicate)
  }
  
  legend.title <- "Sample"
  # add description
  tmp_df <- data.frame(
    sample = as.factor(paste0(result$condition, result$replicate)), 
    data_desc = result$data_desc,
    stringsAsFactors = FALSE
  )
  
  # FIXME
  labels <- dplyr::distinct(tmp_df, sample, data_desc)$data_desc
  
  p <- ggplot2::ggplot(
    result, 
    ggplot2::aes_(
      x = as.name(column), 
      colour = tmp_df$sample, 
      linetype = tmp_df$sample
    )) +
    ggplot2::xlab(column) +
    ggplot2::ylab("Density") +
    ggplot2::stat_ecdf(geom = "step") + 
    ggplot2::scale_color_manual(
      legend.title,
      values = rep(1:conditions, each = replicates),
      labels = labels
    ) + 
    ggplot2::scale_linetype_manual(
      legend.title,
      values = rep(1:replicates, conditions),
      labels = labels
    )
  
  p
}

#' Plot TODO
#' 
#' TODO
#' 
#' @param result object \code{read_results()}
#' @param ref_field TODO
#' @param ref_base2bc TODO
#' @return Plot TODO
#'
#' @export
plot_base_ref2bc_ratio_matrix <- function(result, ref_field, ref_base2bc = c()) {
  if (is.null(result[["ref_base2bc_ratio"]])) {
    result <- add_ref_base2bc_ratio(result, ref_field)
  }
  # add default data description
  if (is.null(result[[.DATA_DESC]])) {
    result <- add_data_desc(result)
  }
  data_desc <- unique(result$data_desc)
  
  result <- dplyr::select(
    result, 
    contig, start, end, strand, 
    !!.DATA_DESC, 
    ref_base2bc, ref_base2bc_ratio
  )

  result <- result %>% group_by_site() %>% 
    dplyr::mutate(ref_base2bc = .merge_ref_base2bc(ref_base2bc)) %>%
    dplyr::ungroup()
  df <- tidyr::spread(result, !!.DATA_DESC, ref_base2bc_ratio)
  
  if (length(ref_base2bc) > 0) {
    df$ref_base2bc[! df$ref_base2bc %in% ref_base2bc] <- "other"
  }
  
  i <- which(colnames(df) %in% data_desc)
  #df[, i] <- log10(df[, i] + 0.01)
  p <- GGally::ggpairs(df, columns = i, mapping = ggplot2::aes(colour = ref_base2bc, alpha = 1/10)) +
    ggplot2::xlab("base change ratio") + ggplot2::ylab("base change ratio")
  
  p
}

#' Plot TODO
#' 
#' TODO
#' 
#' @param result object \code{read_results()}
#' @param ref_field TODO
#' @param ref_base2bc TODO
#' @return Plot TODO
#'
#' @export
plot_ref_base2bc <- function(result, ref_field, ref_base2bc = c()) {
  if (is.null(result[["ref_base2bc"]])) {
    result <- add_ref_base2bc(result, ref_field)
  }

  result <- dplyr::select(
    result, 
    contig, start, end, strand, 
    ref_base2bc
  )
  
  result <- result %>% group_by_site() %>% 
    dplyr::mutate(ref_base2bc = .merge_ref_base2bc(ref_base2bc)) %>%
    dplyr::ungroup()

  if (length(ref_base2bc) > 0) {
    result$ref_base2bc[! result$ref_base2bc %in% ref_base2bc] <- "other"
  }
  result <- result %>% dplyr::distinct(contig, start, end, strand, ref_base2bc)
  p <- ggplot2::ggplot(result, ggplot2::aes(x = ref_base2bc, fill = ref_base2bc)) + ggplot2::geom_bar() +
    ggplot2::xlab("Base change") + 
    ggplot2::scale_fill_discrete(name = "Base change")
  
  p
}
