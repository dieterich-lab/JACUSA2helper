context(".get_alleles")

test_that(".get_alleles works as expected", {
  expect_equal(
    .get_alleles(c("A", "AC")),
    2
  )
  expect_equal(
    .get_alleles(c("A", "A")),
    1
  )
  expect_equal(
    .get_alleles(c("AC", "AG")),
    3
  )
})