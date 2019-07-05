context("filter_robust_variants")

#test_that("filter_robust_variants fails on != 2 conditions", {
#  expect_error(
#    filter_by_robust_variants(list(condition = c(1, 2, 3))),
#    "Only 2 conditions are supported!"
#  )
#  expect_error(
#    filter_by_robust_variants(list(condition = c(1))),
#    "Only 2 conditions are supported!"
#  )
#})

test_that("filter_robust_variants on data with > 2 alleles per site", {
  msg <- "Data contains sites with >2 alleles. Please remove those sites."
  
  m <- matrix(
    c(
      1, 0, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0
    ),
    byrow = TRUE,
    ncol = length(BASES)
  )
  colnames(m) <- BASES

  df <- data.frame(
    contig = rep(1, 3), start = rep(1, 3), end = rep(2, 3), strand = rep("+", 3),
    condition = c(1, 1, 2),
    replicate = c(1, 2, 1),
    bc = apply(m, 1, function(x) { names(x)[x > 0] } ) %>% lapply(paste0, collapse = "") %>% unlist(),
    base_type = rep("total", 3),
    primary = rep(TRUE, 3),
    bc_A = m[, "A"],
    bc_C = m[, "C"],
    bc_G = m[, "G"],
    bc_T = m[, "T"],
    ref_base = rep("A", 3),
    stringsAsFactors = FALSE
  )
  
  expect_error(filter_by_robust_variants(df), msg)
})

test_that("filter_robust_variants works on 2 condition", {
       #  id cond rep
       #  A  C  G  T
  m <- matrix(
    c(
      0, 1, 0, 0,
      0, 1, 0, 0,
      0, 0, 1, 0
    ),
    byrow = TRUE,
    ncol = length(BASES)
  )
  colnames(m) <- BASES
  
  df <- data.frame(
    contig = rep(1, 3), start = rep(1, 3), end = rep(2, 3), strand = rep("+", 3),
    condition = c(1, 1, 2),
    replicate = c(1, 2, 1),
    bc = apply(m, 1, function(x) { names(x)[x > 0] } ) %>% lapply(paste0, collapse = "") %>% unlist(),
    base_type = rep("total", 3),
    primary = rep(TRUE, 3),
    bc_A = m[, "A"],
    bc_C = m[, "C"],
    bc_G = m[, "G"],
    bc_T = m[, "T"],
    ref_base = rep("C", 3),
    stringsAsFactors = FALSE
  )
  
  expect_equal(
    filter_by_robust_variants(df),
    df
  )
})
