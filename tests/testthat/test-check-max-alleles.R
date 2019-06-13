context("check_max_alleles")

test_that("check_max_alles returns TRUE", {
  expect_equal(
    check_max_alleles(
      data.frame(
        id = c(1, 1, 1, 1),
        condition = c(1, 1, 2, 2),
        bc = c("A", "A", "G", "G"),
        stringsAsFactors = TRUE
      )
    ),
    TRUE
  )
})

test_that("check_max_alles returns FALSE", {
  expect_equal(
    check_max_alleles(
      data.frame(
        id = c(1, 1, 1, 1),
        condition = c(1, 1, 2, 2),
        bc = c("A", "C", "G", "G"),
        stringsAsFactors = TRUE
      )
    ),
    FALSE
  )
})
