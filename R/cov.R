#
.cov <- function(bases, cores = 1) {
  apply_repl(bases, rowSums, cores)
}
