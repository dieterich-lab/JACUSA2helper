# explode/extract bases(0,0,0,0) to
# A, C, G, T
# 0, 0, 0, 0
#' @noRd
extract_bases <- function(bases_str, sep = ",") {
  m <- strsplit(bases_str, sep) %>%
    lapply(as.numeric) %>%
    do.call(rbind, .)
  colnames(m) <- BASES
  
  tibble::as_tibble(m)
}

#' @noRd
fix_empty_bases <- function(bases_str) {
  # replace EMPTY base call vectors with 0,0,0,0
  empty_bases_i <- bases_str == EMPTY
  if (any(empty_bases_i)) {
    bases_str[empty_bases_i] <- paste0(rep(0, length(BASES)), collapse = ",")
  }
  
  bases_str
}