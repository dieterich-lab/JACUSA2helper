context("check_max_alleles")

test_that("check_max_alleles returns TRUE", {
  expect_equal(
    check_max_alleles(
      data.frame(
        contig = c(1, 1, 1, 1), start = c(1, 1, 1, 1), end = c(2, 2, 2, 2), strand = c("+", "+", "+", "+"),
        condition = c(1, 1, 2, 2),
        bc = c("A", "A", "G", "G"),
        ref_base = c("A", "A", "A", "A"),
        stringsAsFactors = FALSE
      )
    ),
    TRUE
  )
})

test_that("check_max_alleles returns TRUE", {
  expect_equal(
    check_max_alleles(
      data.frame(
        contig = c(1, 1, 1, 1), start = c(1, 1, 1, 1), end = c(2, 2, 2, 2), strand = c("+", "+", "+", "+"),
        condition = c(1, 1, 2, 2),
        bc = c("A", "A", "G", "G"),
        ref_base = c("C", "C", "C", "C"),
        stringsAsFactors = FALSE
      ),
      use_ref_base = FALSE
    ),
    TRUE
  )
})

test_that("check_max_alleles returns FALSE", {
  expect_equal(
    check_max_alleles(
      data.frame(
        contig = c(1, 1, 1, 1), start = c(1, 1, 1, 1), end = c(2, 2, 2, 2), strand = c("+", "+", "+", "+"),
        condition = c(1, 1, 2, 2),
        bc = c("A", "A", "G", "G"),
        ref_base = c("C", "C", "C", "C"),
        stringsAsFactors = FALSE
      )
    ),
    FALSE
  )
})

test_that("check_max_alleles returns FALSE", {
  expect_equal(
    check_max_alleles(
      data.frame(
        contig = c(1, 1, 1, 1), start = c(1, 1, 1, 1), end = c(2, 2, 2, 2), strand = c("+", "+", "+", "+"),
        condition = c(1, 1, 2, 2),
        bc = c("A", "C", "G", "G"),
        ref_base = c("A", "A", "A", "A"),
        stringsAsFactors = FALSE
      )
    ),
    FALSE
  )
})
