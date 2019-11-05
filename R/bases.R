# explode/extract bases(0,0,0,0) to
# A, C, G, T
# 0, 0, 0, 0
#' @noRd
extract_bases <- function(base_str, sep = ",") {
  m <- strsplit(base_str, sep) %>%
    lapply(as.numeric) %>%
    do.call(rbind, .)
  colnames(m) <- BASES
  
  tibble::as_tibble(m)
}

# replace EMPTY base call vectors with 0,0,0,0
#' @noRd
fix_empty_bases <- function(base_str) {
  empty_bases_i <- base_str == EMPTY
  if (any(empty_bases_i)) {
    base_str[empty_bases_i] <- paste0(rep(0, length(BASES)), collapse = ",")
  }
  
  base_str
}
