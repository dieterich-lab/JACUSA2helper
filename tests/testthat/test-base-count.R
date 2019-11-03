context("base_count")

test_that("base_count works as expected", {
  expect_equal(
    base_count(c("A", "AC")),
    c(1, 2)
  )
  expect_equal(
    base_count(c("A", "AC"), c("A", "T")),
    c(1, 3)
  )
  expect_equal(
    base_count(c("A", "AC"), c("C", "C")),
    c(2, 2)
  )
})
