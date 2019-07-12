context("check_max_alleles")

create_result <- function() {
  r <- tibble::tribble(
    ~contig, ~start, ~end, ~strand, ~condition, ~replicate, ~primary, ~base_type,
          1,      1,    2,     "+",          1,          1,     TRUE,    "total",
          1,      1,    2,     "+",          1,          2,     TRUE,    "total",
          1,      1,    2,     "+",          2,          1,     TRUE,    "total",
          1,      1,    2,     "+",          2,          2,     TRUE,    "total",
  )
  
  r
}


test_that("check_max_alleles returns TRUE", {
  r <- create_result()
  r[["bc"]] <- c("A", "A", "G", "G")
  r[["ref_base"]] <- c("A", "A", "A", "A")

  expect_equal(
    check_max_alleles(r),
    TRUE
  )
})

test_that("check_max_alleles returns TRUE", {
  r <- create_result()
  r[["bc"]] <- c("A", "A", "G", "G")
  r[["ref_base"]] <- c("C", "C", "C", "C")

  expect_equal(
    check_max_alleles(r, use_ref_base = FALSE),
    TRUE
  )
})

test_that("check_max_alleles returns FALSE", {
  r <- create_result()
  r[["bc"]] <- c("A", "A", "G", "G")
  r[["ref_base"]] <- c("C", "C", "C", "C")
  expect_equal(
    check_max_alleles(r),
    FALSE
  )
})

test_that("check_max_alleles returns FALSE", {
  r <- create_result()
  r[["bc"]] <- c("A", "C", "G", "G")
  r[["ref_base"]] <- c("A", "A", "A", "A")
  expect_equal(
    check_max_alleles(r),
    FALSE
  )
})
