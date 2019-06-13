context("filter_robust_variants")

.DF <- data.frame(
  id = c(), 
  condition = c(), replicate = c(), 
  bc_A = c(), bc_C = c(), bc_G = c(), bc_T = c(),
  bc = c(),
  coverage = c(),
  stringsAsFactors = FALSE
)

.a <- function(df, id, cond, rep, bc_A, bc_C, bc_G, bc_T) {
  bc <- ""
  if (bc_A > 0) {
    bc <- paste0(bc, "A")
  }
  if (bc_C > 0) {
    bc <- paste0(bc, "C")
  }
  if (bc_G > 0) {
    bc <- paste0(bc, "G")
  }
  if (bc_T > 0) {
    bc <- paste0(bc, "T")
  }
  
  rbind(df, data.frame(
    id = id,
    condition = cond, replicate = rep,
    bc_A = bc_A, bc_C = bc_C, bc_G = bc_G, bc_T = bc_T,
    bc = bc,
    coverage = bc_A + bc_C + bc_G + bc_T
  ))
}

test_that("filter_robust_variants fails on != 2 conditions", {
  expect_error(
    filter_robust_variants(list(condition = c(1, 2, 3))),
    "Only 2 conditions are supported!"
  )
  expect_error(
    filter_robust_variants(list(condition = c(1))),
    "Only 2 conditions are supported!"
  )
})

test_that("filter_robust_variants on data with > 2 alleles per site", {
  msg <- "Data contains sites with >2 alleles. Please remove those sites."
  expect_error(
    filter_robust_variants(
      #    id cond rep
      #    A  C  G  T
      .a(.DF, 
           1, 1, 1, 
           1, 0, 0, 0) %>%
        .a(1, 1, 2, 
           0, 1, 0, 0)  %>%
        .a(1, 2, 1, 
           0, 0, 1, 0)
    ), msg
  )
})

test_that("filter_robust_variants works on 2 condition", {
       #  id cond rep
       #  A  C  G  T
  d <- .a(.DF,
          1, 1, 1, 
          0, 1, 0, 0) %>%
       .a(1, 1, 2, 
          0, 1, 0, 0)  %>%
       .a(1, 2, 1, 
          0, 0, 1, 0)
  
  expect_equal(
    filter_robust_variants(d),
    d
  )
})
