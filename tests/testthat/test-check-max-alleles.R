context("check_max_alleles")

test_that("check_max_alleles returns TRUE", {
  expect_equal(
    check_max_alleles(
      data.frame(
        id = c(1, 1, 1, 1),
        condition = c(1, 1, 2, 2),
        bc = c("A", "A", "G", "G"),
        ref_base = c("A", "A", "A", "A"),
        stringsAsFactors = TRUE
      )
    ),
    TRUE
  )
})

test_that("check_max_alleles returns TRUE", {
  expect_equal(
    check_max_alleles(
      data.frame(
        id = c(1, 1, 1, 1),
        condition = c(1, 1, 2, 2),
        bc = c("A", "A", "G", "G"),
        ref_base = c("C", "C", "C", "C"),
        stringsAsFactors = TRUE
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
        id = c(1, 1, 1, 1),
        condition = c(1, 1, 2, 2),
        bc = c("A", "A", "G", "G"),
        ref_base = c("C", "C", "C", "C"),
        stringsAsFactors = TRUE
      )
    ),
    FALSE
  )
})

test_that("check_max_alleles returns FALSE", {
  expect_equal(
    check_max_alleles(
      data.frame(
        id = c(1, 1, 1, 1),
        condition = c(1, 1, 2, 2),
        bc = c("A", "C", "G", "G"),
        ref_base = c("A", "A", "A", "A"),
        stringsAsFactors = TRUE
      )
    ),
    FALSE
  )
})
