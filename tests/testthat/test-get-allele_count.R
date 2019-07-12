context("get_allele_count")

test_that("get_alleles works as expected", {
  expect_equal(
    get_allele_count(c("A", "AC")),
    2
  )
  expect_equal(
    get_allele_count(c("A", "A")),
    1
  )
  expect_equal(
    get_allele_count(c("AC", "AG")),
    3
  )
})
